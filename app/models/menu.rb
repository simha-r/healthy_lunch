# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  menu_date  :date
#  created_at :datetime
#  updated_at :datetime
#

class Menu < ActiveRecord::Base

  has_many :menu_products
  has_many :products,through: :menu_products


  has_many :lunch_products, -> { where(menu_products: {category: 'lunch'}) },
           :through => :menu_products, source: :product


  has_many :dinner_products, -> { where(menu_products: {category: 'dinner'}) },
           :through => :menu_products, source: :product


  def show_lunch
    hash = {}
    hash[:lunch] = {start_time: lunch_start_time, end_time: lunch_end_time,end_order_time: lunch_order_end_time,
                    products: lunch_products}
  end

  def show_dinner
    hash = {}
    hash[:dinner] = {start_time: dinner_start_time, end_time: dinner_end_time,end_order_time: dinner_order_end_time,
                     products: dinner_products}
  end

  def lunch_start_time
    Time.zone.local(menu_date.year,menu_date.month,menu_date.day,12,0,0)
  end

  def lunch_end_time
    lunch_start_time+6.hours
  end

  def lunch_order_end_time
    lunch_end_time - 0.5.hour
  end

  def dinner_start_time
    Time.zone.local(menu_date.year,menu_date.month,menu_date.day,19,0,0)
  end
  def dinner_end_time
    dinner_start_time+3.hours
  end

  def dinner_order_end_time
    dinner_end_time - 0.5.hour
  end




end