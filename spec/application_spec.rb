require 'item'
require 'item_repository'
require 'order'
require 'order_repository'
require 'application'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'items_orders_test' })
  connection.exec(seed_sql)
end

def create_app(io)
  return Application.new(
    'items_orders_test',
    io,
    @item_repository,
    @order_repository
  )
end

RSpec.describe Application do
  before(:each) do 
    reset_tables
    @item_repository = ItemRepository.new
    @order_repository = OrderRepository.new
  end

  it "prints the menu" do
    io = double :io
    expect(io).to receive(:puts)
      .with('Welcome to the shop!')
        .ordered
    expect(io).to receive(:puts)
      .with('What would you like to do?')
        .ordered
    expect(io).to receive(:puts)
      .with('1 - List all items')
        .ordered
    expect(io).to receive(:puts)
      .with('2 - List all items attached to an order')
        .ordered
    expect(io).to receive(:puts)
      .with('3 - Create a new item')
        .ordered
    expect(io).to receive(:puts)
      .with('4 - List all orders')
        .ordered
    expect(io).to receive(:puts)
      .with('5 - List all orders that contain a specific item')
        .ordered
    expect(io).to receive(:puts)
      .with('6 - Create a new order')
        .ordered

    app = create_app(io)
    app.print_menu
  end

  xit "actions on user selection" do
    io = double :io
    app = create_app(io)
    expect(app).to receive(:print_items)
    app.do_selection(1)
  end

  it "prints all items" do
    io = double :io
    expect(io).to receive(:puts)
      .with('All items:')
        .ordered
    expect(io).to receive(:puts)
      .with("Pizza - Price: £9.99 - Quantity: 100")
        .ordered
    expect(io).to receive(:puts)
      .with("Cake - Price: £4.50 - Quantity: 20")
        .ordered
    expect(io).to receive(:puts)
      .with("Chips - Price: £2.50 - Quantity: 50")
        .ordered
    expect(io).to receive(:puts)
      .with("Burger - Price: £8.49 - Quantity: 12")
        .ordered
    expect(io).to receive(:puts)
      .with("Salad - Price: £0.99 - Quantity: 2")
        .ordered
    expect(io).to receive(:puts)
      .with("Hotdog - Price: £12.50 - Quantity: 99")
        .ordered
    expect(io).to receive(:puts)
      .with("Spagbol - Price: £19.99 - Quantity: 59")
        .ordered

    app = create_app(io)
    app.print_items
  end

  it "prints items by order" do
    io = double :io
    expect(io).to receive(:puts)
      .with("What order do you want to see the items for?")
        .ordered
    expect(io).to receive(:gets)
      .and_return('1')
        .ordered
    expect(io).to receive(:puts)
      .with("Pizza - Price: £9.99 - Quantity: 100")
        .ordered
    expect(io).to receive(:puts)
      .with("Cake - Price: £4.50 - Quantity: 20")
        .ordered
    expect(io).to receive(:puts)
      .with("Chips - Price: £2.50 - Quantity: 50")
        .ordered
     expect(io).to receive(:puts)
      .with("Salad - Price: £0.99 - Quantity: 2")
        .ordered   
    app = create_app(io)
    app.print_items_by_order
  end

  it "creates an item" do
    io = double :io
    expect(io).to receive(:print)
      .with("Name: ")
        .ordered
    expect(io).to receive(:gets)
      .and_return("Enchilada")
        .ordered
    expect(io).to receive(:print)
      .with("Price: ")
        .ordered
    expect(io).to receive(:gets)
      .and_return("7.99")
        .ordered
    expect(io).to receive(:print)
      .with("Quantity: ")
        .ordered
    expect(io).to receive(:gets)
      .and_return("60")
        .ordered
    expect(io).to receive(:puts)
      .with("Item created!")
        .ordered

        
        app = create_app(io)
        app.create_item
        
        new_item = @item_repository.all.last
        expect(new_item.id).to eq 8
        expect(new_item.name).to eq "Enchilada"
        expect(new_item.unit_price).to eq 7.99
        expect(new_item.quantity).to eq 60
  end
end