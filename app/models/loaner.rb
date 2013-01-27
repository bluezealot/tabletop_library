class Loaner < ActiveRecord::Base
    attr_accessible :contact, :name, :phone_number

    has_many :games

    before_save { |loaner| loaner.phone_number = format_phone(loaner.phone_number) }

    validates_uniqueness_of :name
    validates :name, presence: true
    validates_format_of :phone_number, :with => /^\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*$/i

    private

        def format_phone(phone_num)
            p = phone_num.split ""
            np = []
            p.each do |c|
                if /^\d$/.match(c)
                    np.push(c)
                end
            end
            if np.count != 10
                phone_num
            else
                np.insert(3, "-")
                np.insert(7, "-")
                np.join
            end
        end
end
