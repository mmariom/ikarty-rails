class Card < ApplicationRecord
  belongs_to :user, optional: true
  validates :unique_key, presence: true, uniqueness: true
  validates :destination_url, presence: true, format: { with: /\A(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?\z/, message: "musi byt platna adresa" }




  def to_param
    unique_key
  end


  
end
