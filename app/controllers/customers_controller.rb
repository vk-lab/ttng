class CustomersController < AuthenticatedController
  load_and_authorize_resource
  inject :customer_manager
  helper_method :sort_column, :sort_direction

  def index
    @customers = @customers.order("#{sort_column} #{sort_direction}").includes(:projects).paginate(page: params[:page], per_page: 20)
  end

  def new

  end

  def create
    customer_manager.create(customer_params) do |customer, saved|
      if saved
        redirect_to customers_path
      else
        @customer = customer
        render :new
      end
    end
  end

  def edit

  end

  def update
    customer_manager.update(@customer, customer_params) do |customer, saved|
      if saved
        redirect_to customers_path
      else
        @customer = customer
        render :edit
      end
    end
  end

  def destroy
    customer_manager.destroy(@customer)
    redirect_to customers_path
  end

  private

  def customer_params
    CustomerPermitter.permit(params)
  end

  def sort_column
    Customer.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
