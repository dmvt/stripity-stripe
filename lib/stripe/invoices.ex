 defmodule Stripe.Invoices do
  @moduledoc """
  Main API for working with Invoices at Stripe. Through this API you can:
  -create
  -retrieve single
  -list (paged, 100 max/page)
  -count

  All calls have a version with accept a key parameter for leveraging Connect.

  (API ref:https://stripe.com/docs/api#invoices)
  """

  @endpoint "invoices"

  def get(id) do
    get id, Stripe.config_or_env_key
  end

  @doc """
  Retrieves a given Invoice with the specified ID. Returns 404 if not found.
  Using a given stripe key to apply against the account associated.
  ## Example

  ```
  {:ok, cust} = Stripe.Invoices.get "customer_id", key
  ```
  """
  def get(id, key) do
    Stripe.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Returns a list of invoices for a given customer

  ## Example

  ```
  {:ok, invoices} = Stripe.Customers.get_invoices "customer_id"
  ```

  """
 # def get_invoices(id, params \\ []) do
 #   get_invoices id, params, Stripe.config_or_env_key
 # end

  @doc """
  Returns a list of invoices for a given customer
  Using a given stripe key to apply against the account associated.

  ## Example

  ```
  {:ok, invoices} = Stripe.Customers.get_invoices "customer_id", key
  ```
  """
 # def get_invoices(id, params, key) do
 #   params = Keyword.put_new params, :limit, 10
 #   params = Keyword.put_new params, :customer, id
 #   Stripe.Util.list "invoices", key, starting_after, limit
 # end

  @doc """
  Count number of invoices.
  ## Example

  ```
  {:ok, cnt} = Stripe.Invoices.count
  ```
  """
  def count do
    count Stripe.config_or_env_key
  end

  @doc """
  Count number of invoices.
  Using a given stripe key to apply against the account associated.
  ## Example

  ```
  {:ok, cnt} = Stripe.Invoices.count key
  ```
  """
  def count(key) do
    Stripe.Util.count  "#{@endpoint}", key
  end

  @doc """
  Lists invoices with a default limit of 10. You can override this by passing in a l imit.

  ## Examples
  ```
  {:ok, invoices} = Stripe.Invoices.list(starting_after,100)
  ```
  """
  def list(starting_after,limit \\ 10) do
    list Stripe.config_or_env_key, starting_after ,limit
  end

  @doc """
  Lists invoices with a default limit of 10. You can override this by passing in a limit.
  Using a given stripe key to apply against the account associated.

  ## Examples
  ```
  {:ok, invoices} = Stripe.Invoices.list(key,starting_after,100)
  ```
  """
  def list(key,starting_after,limit)  do
    Stripe.Util.list @endpoint, key,  starting_after, limit
  end


  @doc """
  Create invoice according to Stripe's invoice rules. This is not the same as a charge.

  ## Example

  ```
  params = [
    subscription: "subscription_id"
    metadata: [
        app_order_id: "ABC123",
        app_attr1: "xyz"
    ]
  ]
  {:ok, invoice} = Stripe.Invoices.create "customer_id", params
  ```
  """
  def create(customer_id, params) do
    create customer_id, params, Stripe.config_or_env_key
  end

  @doc """
  Create invoice according to Stripe's invoice rules. This is not the same as a charge.
  Using a given stripe key to apply against the account associated.

  ## Example

  ```
  params = [
    subscription: "subscription_id"
    metadata: [
        app_order_id: "ABC123",
        app_attr1: "xyz"
    ]
  {:ok, invoice} = Stripe.Invoices.create "customer_id", params, key
  ```
  """
  def create(customer_id, params, key) do
    params = Keyword.put_new params, :customer, customer_id
    Stripe.make_request_with_key(:post, "invoices", key, params)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Retrieve the upcoming invoice for a customer that will show you all the charges that are pending, including subscription renewal charges, invoice item charges, etc.
  It will also show you any discount that is applicable to the customer. NOTE: this is a preview, not a created invoice

  ## Example

  ```
  {:ok, upcoming_invoice} = Stripe.Invoices.upcoming "customer_id", [subscription: "sub_id"]
  ```
  """
  def upcoming(customer_id, params) do
    upcoming customer_id, params, Stripe.config_or_env_key
  end

  @doc """
  Retrieve the upcoming invoice for a customer that will show you all the charges that are pending, including subscription renewal charges, invoice item charges, etc.
  It will also show you any discount that is applicable to the customer. NOTE: this is a preview, not a created invoice
  Using a given stripe key to apply against the account associated.

  ## Example

  ```
  {:ok, upcoming_invoice} = Stripe.Invoices.upcoming "customer_id", [subscription: "sub_id"], "key"
  ```
  """
  def upcoming(customer_id, params, key) do
    params = Keyword.put_new params || [], :customer, customer_id
    Stripe.make_request_with_key(:get, "#{@endpoint}/upcoming", key, params)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Stripe automatically creates and then attempts to pay invoices for customers on subscriptions.
  However, if you’d like to attempt to collect payment on an invoice out of the normal retry schedule or for some other reason, you can do so.

  ## Example
  {:ok, invoice} = Stripe.Invoices.pay "invoice_id"
  """
  def pay(invoice_id) do
    pay invoice_id, Stripe.config_or_env_key
  end

  @doc """
  Stripe automatically creates and then attempts to pay invoices for customers on subscriptions.
  However, if you’d like to attempt to collect payment on an invoice out of the normal retry schedule or for some other reason, you can do so.

  ## Example
  {:ok, invoice} = Stripe.Invoices.pay "invoice_id", key
  """
  def pay(invoice_id, key) do
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{invoice_id}/pay", key)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Updates an Invoice with the given parameters - all of which are optional.

  ## Example

  ```
    new_fields = [
      application_fee: 100,
      description: "New description",
    ]
    {:ok, res} = Stripe.Invoices.update(invoice_id, new_fields)
  ```
  """
  def update(invoice_id, params) do
    update(invoice_id, params, Stripe.config_or_env_key)
  end

  @doc """
  Updates a Invoice with the given parameters - all of which are optional.
  Using a given stripe key to apply against the account associated.

  ## Example
  ```
  {:ok, res} = Stripe.Invoices.update(invoice_id, new_fields, key)
  ```
  """
  def update(invoice_id, params, key_or_headers) when is_bitstring(key_or_headers) do
    Stripe.make_request_with_key(
      :post, "#{@endpoint}/#{invoice_id}", key_or_headers, params
    )
    |> Stripe.Util.handle_stripe_response
  end

  def update(invoice_id, params, key_or_headers) when is_map(key_or_headers) do
    Stripe.make_request_with_key(
      :post,
      "#{@endpoint}/#{invoice_id}",
      Stripe.config_or_env_key,
      params,
      key_or_headers
    )
    |> Stripe.Util.handle_stripe_response
  end
end
