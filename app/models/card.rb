class Card < ApplicationRecord
  belongs_to :user, optional: true
  has_many :visits
  has_many :daily_visit_summaries

  
  validates :unique_key, presence: true, uniqueness: true
  validates :destination_url, presence: true, format: { with: /\A(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{1,}(\/\S*)?\z/, message: "musí byť platná emailová adresa" },
                                              length: { maximum: 255, message: "nemôže mať viac ako 255 znakov" }   

  validates :location, length: { maximum: 60, message: "nemôže mať viac ako 60 znakov" }






  def to_param
    unique_key
  end


  
end
