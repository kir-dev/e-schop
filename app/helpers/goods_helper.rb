module GoodsHelper

    def get_image(good)
        if good.photo.attached? 
            image=  good.photo
        else 
            if defined?@products
                product = @products.find_by_id(good.product_id) 
                if product.photo.attached? 
                    image=product.photo
                end  
            else
                image=Product.find_by_id(good.product_id).photo
            end
        end 
        image
    end

end
