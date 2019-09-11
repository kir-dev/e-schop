class UserMailer < ApplicationMailer
    default from: "eschop@example.com"

    def to_sold_goods_mail
        receiver = params[:receiver]
        if receiver.want_email
            @url = url_for(controller: 'users', action: 'good_show', purchase_id: params[:purchase_id], id: params[:good_id])
            @body = params[:body]
            mail(to: receiver.email, subject: "Megrendelt termék")
        end
    end

    def back_from_cart_mail
        receiver = params[:receiver]
        if receiver.want_email
            @url = url_for(controller: 'users', action: 'sold_goods')
            @body = params[:body]
            mail(to: receiver.email, subject: "Lemondott rendelés")
        end
    end

    def purchase_paid_mail
        receiver = params[:receiver_id]
        if receiver.want_email
            @url = url_for(controller: 'users', action: 'my_cart')
            @body = params[:body]
            mail(to: receiver.email, subject: "Fizetés jóváhagyva")
        end
    end
end
