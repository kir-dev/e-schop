module ProductsHelper
    def get_proucts_for_goods(goods)
        
        Product.with_attached_photo.where(id:goods.ids)
      end
end
