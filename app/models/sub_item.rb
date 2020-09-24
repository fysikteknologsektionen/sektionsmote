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
      "§#{item.position}.#{position} #{title}"
    else
      item.to_s
    end
  end

  def list
    if item.multiple?
      str = "§#{item.position}.#{position}"
      str += I18n.t('model.item.deleted') if deleted?
      str
    else
      item.list
    end
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def self.set_next_active
    #Fixa så inte gå vidare vid öppen votering

    sub_item = where(status: :current).take
    
    if sub_item # Kolla om en aktiv punkts finns
      
      #Kolla om öppen votering
      item = Vote.where(status: :open).first
      if !item.nil? && item.sub_item_id == id
        errors.add(:status, I18n.t('model.sub_item.errors.vote_open'))
        return 
      end
  
      pItem = Item.where(id: sub_item.item_id).take #Hitta parent punkten

      if pItem.multiplicity? # om den har underpunkter

        nSubItemPos = sub_item.position + 1 #Näsa underpunktsindex
        nSubItem = where(position: nSubItemPos, item_id: sub_item.item_id).take

        if nSubItem #Kolla om nästa underpunkt existerar
          where(status: :current).update_all(status: :closed)
          where(item_id: sub_item.item_id,position: nSubItemPos, deleted_at: nil).update_all(status: :current)
        else # Om den inte har någon underpunkt efter ex: 1.3 => 2.0
          
          nPos = pItem.position + 1
          nItem = Item.where(position: nPos, deleted_at: nil).take
          if nItem
            where(status: :current).update_all(status: :closed)
            where(item_id: nItem.id,position: 1, deleted_at: nil).update_all(status: :current)
          else
            #Todo: error

          end
        end
      else #Om den inte har underpunkter
        # Osäker på om denna del faktiskt används
        nextPos = pItem.position + 1
        nItem = Item.where(position: nextPos, deleted_at: nil).take
        if nItem
          nId = nItem.id
          puts ("ID")
          puts ("ID")
          puts ("ID")
          puts ("ID")
          puts nId
          where(status: :current).update_all(status: :closed)
          where(item_id: nId, deleted_at: nil).update_all(status: :current)
        else
          #Todo: error
        end
      end
    end
  end

  def self.set_prev_active
    sub_item = where(status: :current).take
    
    if sub_item # Kolla om en aktiv punkts finns
      
      #Kolla om öppen votering
      item = Vote.where(status: :open).first
      if !item.nil? && item.sub_item_id == id
        errors.add(:status, I18n.t('model.sub_item.errors.vote_open'))
        return 
      end

      pItem = Item.where(id: sub_item.item_id).take #Hitta parent punkten

      if pItem.multiplicity? # om den har underpunkter

        
        nSubItemPos = sub_item.position - 1 #föregående underpunktsindex
        

        if nSubItemPos > 0 #Kolla om föregående underpunkt existerar
          where(status: :current).update_all(status: :future)
          where(item_id: sub_item.item_id, position: nSubItemPos, deleted_at: nil).update_all(status: :current)

        else # Om den inte har någon underpunkt före ex: 2.1 => 1.x
          prevPPos = pItem.position - 1
          prevPItem = Item.where(position: prevPPos).take

          if prevPItem # om föregående punkt existerar
            if prevPItem.multiplicity?
              where(status: :current).update_all(status: :future)
              lastSubItem = where(item_id: prevPItem.id, deleted_at: nil).last
              where(item_id: lastSubItem.item_id, position: lastSubItem.position, deleted_at: nil).update_all(status: :current)
            else
              where(status: :current).update_all(status: :future)
              where(item_id: prevPItem.id, deleted_at: nil).update_all(status: :current)
            end
          else # Om den inte existerar
            #Todo: error
          end
        end
      else #Om den inte har underpunkter
        prevPos = pItem.position - 1
        nItem = Item.where(position: nextPos, deleted_at: nil).take
        if nItem
          nId = nItem.id
          where(status: :current).update_all(status: :future)
          where(item_id: nId, deleted_at: nil).update_all(status: :current)
        else
          #Todo: error
        end
      end
    end
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

end
