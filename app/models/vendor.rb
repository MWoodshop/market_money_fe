# class Vendor < ApplicationRecord
#   has_many :market_vendors
#   has_many :markets, through: :market_vendors

#   validates :name, presence: true
#   validates :description, presence: true
#   validates :contact_name, presence: true
#   validates :contact_phone, presence: true
#   validates :credit_accepted, inclusion: { in: [true, false] }
# end

# ***** Models likely not needed as this is a FE only application. Delete on refactor ******