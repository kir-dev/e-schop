# frozen_string_literal: true

module GoodsHelper
  def get_image(item, format = 'default')
    formats = {
      'list' => '400x400!',
      'cart' => '100x100!'
    }

    image = nil
    if item.photo.attached?
      image = item.photo

    elsif item.instance_of? Good
      if !@products.nil? && @products.any? { |p| p.id == item.product_id }
        product = @products.find { |p| p.id == item.product_id }
        image = product.photo if product.photo.attached?
      else

        product = Product.find_by_id(item.product_id)
        image = product.photo if product.photo.attached?
      end
    end

    if image.nil?
      return "default#{formats[format]}.jpg" unless format == 'default'

      return 'default.jpg'
    else
      unless format == 'default'
        image = image.variant(resize: formats[format]).processed
      end
      return image
    end
  end

  def find_seller(id)
  
    seller = @sellers.select{|seller| seller.id==id}
    if seller.nil?
      seller = User.find(id)
    elsif seller.kind_of?(Array)
      seller = seller.first 
    end
    seller
  end


end
