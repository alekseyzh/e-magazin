require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products
	test "product is not valid without a unique title" do
	# если у товара нет уникального названия, то он недопустим
	product = Product.new( title: products(:ruby).title,
		description: "some text",
		price: 1,
		image_url: "fred.gif") 
	assert !product.save
	assert_equal I18n.translate('activerecord.errors.messages.taken'),
	product.errors[:title].join('; ')
end

test "product attributes must not be empty" do 
	# свойства товара не должны быть пустыми
	product = Product.new
	assert product.invalid?
	assert product.errors[:title].any?
	assert product.errors[:description].any?
	assert product.errors[:image_url].any?
	assert product.errors[:price].any?
end

test "product price must be positive" do
	# цена товара должна быть положительной
	product = Product.new(title: "Новая паяльная станция",
		description: "some text",
		image_url: "image.jpg"
		)
	product.price = -1
	assert product.invalid?
	assert_equal "must be greater than or equal to 0.01",
	product.errors[:price].join('; '),
	
	product.price = 0
	assert product.invalid?
	assert_equal "must be greater than or equal to 0.01",
	product.errors[:price].join('; ')
	product.price = 1
	assert product.valid?

def new_product(image_url)
		Product.new(title: "Новая паяльная станция",
		description: "some text",
		price: 1,
		image_url: image_url
		)
	end

test "image_url" do
	# URL изображения
	ok = %w{ fred.gif fred.jpg fred.png FRED.GIF FRED.Gif http://a.b.c/x/y/z/fred.jpg }
	bad = %w{ fred.doc fred.gif/more fred.gif.more}

	ok.each do |name|
		assert new_product(name).valid?, "#{name} shouldn't be invalid" 
	end

	bad.each do |name|
		assert new_product(name).invalid?, "#{name} shouldn't be valid"
	end
end
