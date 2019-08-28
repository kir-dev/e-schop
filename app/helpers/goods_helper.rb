module GoodsHelper

    def get_image(item,format="default")
        formats={
             "list" => "400x400!", 
             "cart" => "100x100!"}

        image=nil
        if item.photo.attached? 
            image= item.photo

        elsif item.instance_of? Good
            if !@products.nil? && @products.any?{|p| p.id == item.product_id}
                product = @products.find{|p| p.id == item.product_id}
                if product.photo.attached? 
                    image= product.photo

                end
            else

                product = Product.find_by_id(item.product_id)
                if product.photo.attached? 
                    image=   product.photo
                end 
            end
        end
        
        if image.nil?
            unless format=="default"
                return"default#{formats[format]}.jpg"
            end
            return "default.jpg"
        else
            unless format=="default"
                image=image.variant(resize: formats[format]).processed
            end
            return image
        end
    end

end
