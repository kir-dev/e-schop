module GoodsHelper

    def get_image(good,format="default")
        
        formats={
             "list" => "400x400!", 
             "cart" => "100x100!"}

        image=nil
        if good.photo.attached? 
            image= good.photo

        elsif !@products.nil? && @products.any?{|p| p.id == good.product_id}
                product = @products.find{|p| p.id == good.product_id}
                if product.photo.attached? 
                    image= product.photo

                end
        else 

            product = Product.find_by_id(good.product_id)
            if product.photo.attached? 
                image=   product.photo
                 
            

            end
        end
        
        if image.nil?
         return'default.jpg'
        else

            unless format=="default"
                image=image.variant(resize: formats[format]).processed
            end
            return image
        end
    end

end
