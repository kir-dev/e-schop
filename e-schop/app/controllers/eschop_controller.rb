class EschopController < ApplicationController

    def index
    end

    def list
        @goods = Good.all
    end

    def new_good
    end

    def create_good
    end

    def delete_good
    end
end
