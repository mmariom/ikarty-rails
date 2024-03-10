class Card < ApplicationRecord
  belongs_to :user, optional: true
  validates :unique_key, presence: true, uniqueness: true
  validates :destination_url, presence: true, format: { with: /\A(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{1,}(\/\S*)?\z/, message: "musí byť platná emailová adresa" },
                                              length: { maximum: 2048, message: "nemôže mať viac ako 2048 znakov" }   

  validates :location, length: { maximum: 60, message: "nemôže mať viac ako 60 znakov" }

  validates :redirect_counter, numericality: { greater_than_or_equal_to: 0 }




  def to_param
    unique_key
  end


  
end
