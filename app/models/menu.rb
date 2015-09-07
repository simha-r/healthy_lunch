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


  has_many :menu_lunch_products,-> { where(menu_products: {category: 'lunch'}) }, class_name: 'MenuProduct'
  has_many :menu_dinner_products,-> { where(menu_products: {category: 'dinner'}) }, class_name: 'MenuProduct'

  has_many :lunch_products, -> { where(menu_products: {category: 'lunch'}) },
           :through => :menu_products, source: :product


  has_many :dinner_products, -> { where(menu_products: {category: 'dinner'}) },
           :through => :menu_products, source: :product


  def self.today
    where(menu_date: Date.current).first
  end

  def self.tomorrow
    where(menu_date: Date.tomorrow).first
  end

  def self.current_lunch
    if today
      if Time.now < today.lunch_order_end_time
        today
      else
        tomorrow
      end
    else
      tomorrow
    end
  end

  def self.current_dinner
    if today
      if Time.now < today.dinner_order_end_time
        today
      else
        tomorrow
      end
    else
      tomorrow
    end
  end

  def show_lunch
    hash = {}
    hash[:lunch] = {start_time: lunch_start_time, end_time: lunch_end_time,end_order_time: lunch_order_end_time,

    products: menu_lunch_products.includes(:product).collect{|menu_product| menu_product.product.as_json.merge(menu_product_id: menu_product.id,sold_out: menu_product.sold_out)}}
  end

  def show_dinner
    hash = {}
    hash[:dinner] = {start_time: dinner_start_time, end_time: dinner_end_time,end_order_time: dinner_order_end_time,
                     products: menu_dinner_products.includes(:product).collect{|menu_product| menu_product.product.as_json.merge(menu_product_id: menu_product.id,sold_out: menu_product.sold_out)}}

  end

  def lunch_start_time
    Time.zone.local(menu_date.year,menu_date.month,menu_date.day,MenuProduct::LUNCH_START_TIME,0,0)
  end

  def lunch_end_time
    lunch_start_time+3.5.hours
  end

  def lunch_order_end_time
    lunch_end_time - 0.5.hour
  end

  def dinner_start_time
    Time.zone.local(menu_date.year,menu_date.month,menu_date.day,MenuProduct::DINNER_START_TIME,0,0)
  end
  def dinner_end_time
    dinner_start_time+3.5.hours
  end

  def dinner_order_end_time
    dinner_end_time - 0.5.hour
  end

end
