# == Schema Information
#
# Table name: growth_partners
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  phone_number :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class GrowthPartner < ActiveRecord::Base
end
