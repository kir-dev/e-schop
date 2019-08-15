module GoodsHelper

    def get_image(good)
        
    
        if good.photo.attached? 
           return image_tag  good.photo
            puts "good"

        elsif !@products.nil? && @products.any?{|p| p.id == good.product_id}
                product = @products.find{|p| p.id == good.product_id}
                if product.photo.attached? 
                  return  image_tag product.photo
                    puts "products"

                end
        else 

            product = Product.find_by_id(good.product_id)
            if product.photo.attached? 
              return  image_tag product.photo
                puts "database"
                 
            

            end
        end
        
        image_tag 'default.jpg'
        
    end

end
