module ParamsHelper
    def copy_params_to_shash
        copy_prams=["order_by","order_direction","searched_phrase","page","selected_floors","selected_tags","deleted_tag","prev_tags"]
        copy_prams.each do|param|
            if !params[param].nil?
                session[param]=params[param]
            end
        end
    end

    def get_params_from_shash
        copy_prams=["order_by","order_direction","searched_phrase","page","selected_floors","selected_tags","deleted_tag","prev_tags"]
        copy_prams.each do|param|
            if !session[param].nil?
                params[param]=session[param]
            end
        end
    end

    def delete_params_from_shash
        copy_prams=["order_by","order_direction","searched_phrase","page","selected_floors","selected_tags","deleted_tag","prev_tags"]
        copy_prams.each do|param|
            session[param]=nil
        end
    end
end