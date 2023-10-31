# frozen_string_literal: true

module Admin
  # Sets current agenda item
  class CurrentItemsController < Admin::BaseController
    authorize_resource(class: Item)

    def update
      if params[:id] == 'close_all'
        SubItem.set_all_closed
        redirect_to admin_items_path
        return
      end
      if params[:id] == 'open_all'
        SubItem.set_all_future
        redirect_to admin_items_path
        return
      end
      if params[:id] == 'next_active'
        SubItem.set_next_active
        redirect_to admin_items_path
        return
      end
      if params[:id] == 'prev_active'
        SubItem.set_prev_active
        redirect_to admin_items_path
        return
      end
      

      @sub_item = SubItem.includes(:item).find(params[:id])
      @success = @sub_item.update(status: :current)
    end

    def destroy
      @sub_item = SubItem.includes(:item).find(params[:id])
      @success = @sub_item.update(status: :closed)
    end
  end
end
