# frozen_string_literal: true

class SubItem < ApplicationRecord
  acts_as_paranoid
  acts_as_list(scope: [:item_id, deleted_at: nil])
  belongs_to(:item, -> { with_deleted }, inverse_of: :sub_items)
  has_many(:votes, -> { position }, dependent: :destroy)
  has_many_attached(:documents)

  validates(:title, presence: true)
  validates(:status,
            if: :current?,
            uniqueness: {
              message: I18n.t('model.sub_item.errors.already_one_current')
            })
  validate(:number_of_sub_items, on: :create)
  validate(:no_open_votes, on: :update)

  # There is a DB-constraint to assure uniqueness for status < 0,
  # only set statuses that should be unique to values below 0.
  enum(status: { current: -10, future: 0, closed: 10 })
  scope(:position, -> { order(:position) })
  scope(:full_order, lambda do
    joins(:item).order('items.position ASC, sub_items.position ASC')
  end)
  scope(:not_closed, -> { where(status: %i[current future]) })

  def self.current
    where(status: :current).first
  end

  def to_s
    if item.multiple?
      "§#{item.position}#{position_to_s} #{title}"
    else
      item.to_s
    end
  end

  def list
    if item.multiple?
      str = "§#{item.position}#{position_to_s}"
      str += I18n.t('model.item.deleted') if deleted?
      str
    else
      item.list
    end
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def next
    if item.multiple?
      item.sub_items.each_cons(2) do |sub, sub_next|
        return sub_next if id === sub.id
      end
    end
    return item.next&.sub_items&.first
  end
  
  def prev
    if item.multiple?
      item.sub_items.each_cons(2) do |sub, sub_next|
        return sub if id === sub_next.id
      end
    end
    return item.prev&.sub_items&.last
  end

  def self.set_next_active
    cur = self.current
    
    # require active item
    return unless cur
      
    # check no vote open
    if Vote.current&.sub_item_id === cur.id
      errors.add(:status, I18n.t('model.sub_item.errors.vote_open'))
      return 
    end

    # close current
    where(status: :current).update_all(status: :closed)
  
    new = cur.next
    return if new.nil?

    where(id: new.id).update_all(status: :current)
  end

  def self.set_prev_active
    cur = self.current
    
    # require active item
    return unless cur

    # check no vote open
    if Vote.current&.sub_item_id === cur.id
      errors.add(:status, I18n.t('model.sub_item.errors.vote_open'))
      return 
    end

    # close current
    where(status: :current).update_all(status: :future)
  
    new = cur.prev
    return if new.nil?

    where(id: new.id).update_all(status: :current)
  end

  def self.set_all_future
    where(deleted_at:  nil).update_all(status: :future)
  end

  def self.set_all_closed
    where(deleted_at: nil).update_all(status: :closed)
  end
  private

  def number_of_sub_items
    return if item.multiple? || item.sub_items.select(&:persisted?).empty?
    errors.add(:multiplicity, I18n.t('model.sub_item.errors.count_not_allowed'))
  end

  def no_open_votes
    return unless status_changed?(from: 'current') &&
                  votes.present? &&
                  !votes.current.blank?

    errors.add(:status, I18n.t('model.sub_item.errors.vote_open'))
  end

  def position_to_s
    if item.position.to_i.to_s === item.position
      position.alph
    else
      "." + position.roman
    end
  end
end
