defmodule Stripe.Plans do
  @moduledoc """
  Basic List, Create, Delete API for Plans
  """

  @endpoint "plans"

  @doc """
  Creates a Plan. Note that `currency` and `interval` are required parameters, and are defaulted to "USD" and "month"

  ## Example

  ```
    {:ok, plan} = Stripe.Plans.create [id: "test-plan", name: "Test Plan", amount: 1000, interval: "month"]
  ```
  """
  def create(params) do
    create params, Stripe.config_or_env_key
  end

  @doc """
  Creates a Plan using a given key. Note that `currency` and `interval` are required parameters, and are defaulted to "USD" and "month"

  ## Example

  ```
  {:ok, plan} = Stripe.Plans.create [id: "test-plan", name: "Test Plan", amount: 1000, interval: "month"], key
  ```
  """
  def create(params, key_or_headers) when is_bitstring(key_or_headers) do
    #default the currency and interval
    params = Keyword.put_new params, :currency, "USD"
    params = Keyword.put_new params, :interval, "month"

    Stripe.make_request_with_key(:post, @endpoint, key_or_headers, params)
    |> Stripe.Util.handle_stripe_response
  end

  def create(params, key_or_headers) when is_map(key_or_headers) do
    #default the currency and interval
    params = Keyword.put_new params, :currency, "USD"
    params = Keyword.put_new params, :interval, "month"

    Stripe.make_request_with_key(
      :post,
      @endpoint,
      Stripe.config_or_env_key,
      params,
      key_or_headers
    )
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Retrieves a given Plan with the specified ID. Returns 404 if not found.
  ## Example

  ```
    {:ok, cust} = Stripe.Plans.get "plan_id"
  ```

  """
  def get(id) do
    get id, Stripe.config_or_env_key
  end

  @doc """
  Retrieves a given Plan with the specified ID. Returns 404 if not found.
  Using a given stripe key to apply against the account associated.
  ## Example

  ```
  {:ok, cust} = Stripe.Plans.get "plan_id", key
  ```
  """
  def get(id, key_or_headers) when is_bitstring(key_or_headers) do
    Stripe.make_request_with_key(:get, "#{@endpoint}/#{id}", key_or_headers)
    |> Stripe.Util.handle_stripe_response
  end

  def get(id, key_or_headers) when is_map(key_or_headers) do
    Stripe.make_request_with_key(
      :get,
      "#{@endpoint}/#{id}",
      Stripe.config_or_env_key,
      [],
      key_or_headers
    )
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Returns a list of Plans.
  """
  def list(limit \\ 10) do
    list Stripe.config_or_env_key, limit
  end

  @doc """
  Returns a list of Plans using the given key.
  """
  def list(key, limit) do
    Stripe.make_request_with_key(:get, "#{@endpoint}?limit=#{limit}", key)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Deletes a Plan with the specified ID.

  ## Example

  ```
    {:ok, res} = Stripe.Plans.delete "test-plan"
  ```

  """
  def delete(id) do
    delete id, Stripe.config_or_env_key
  end

  @doc """
  Deletes a Plan with the specified ID using the given key.

  ## Example

  ```
  {:ok, res} = Stripe.Plans.delete "test-plan", key
  ```

  """
  def delete(id, key) do
    Stripe.make_request_with_key(:delete, "#{@endpoint}/#{id}", key)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Changes Plan information. See Stripe docs as to what you can change.

  ## Example

  ```
    {:ok, plan} = Stripe.Plans.change("test-plan",[name: "Other Plan"])
  ```
  """
  def change(id, params) do
    change(id, params, Stripe.config_or_env_key)
  end

  def change(id, params, key) do
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{id}", key, params)
    |> Stripe.Util.handle_stripe_response
  end

  def count do
    count Stripe.config_or_env_key
  end
  def count(key) do
    Stripe.Util.count  "#{@endpoint}", key
  end

  @max_fetch_size 100
  @doc """
  List all plans.
  ##Example
  ```
  {:ok, plans} = Stripe.Plans.all
      ```
      """
  def all( accum \\ [], startingAfter \\ "") do
    all Stripe.config_or_env_key, accum, startingAfter
  end

  @max_fetch_size 100
  @doc """
  List all plans w/ given key.
  ##Example
  ```
  {:ok, plans} = Stripe.Plans.all key
  ```
  """
  def all( key, accum, startingAfter) do
    case Stripe.Util.list_raw("#{@endpoint}",key, @max_fetch_size, startingAfter) do
    {:ok, resp}  ->
      case resp[:has_more] do
        true ->
          last_sub = List.last( resp[:data] )
          all( key, resp[:data] ++ accum, last_sub["id"] )
        false ->
          result = resp[:data] ++ accum
          {:ok, result}
      end
    end
  end

  @doc """
  Deletes all Plans
  ## Example
  ```
  Stripe.Plans.delete_all
  ```
  """
  def delete_all do
    delete_all Stripe.config_or_env_key
  end


  @doc """
  Deletes all Plans w/given key
  ## Example
  ```
  Stripe.Plans.delete_all key
  ```
  """
  def delete_all key do
    case all() do
      {:ok, plans} ->
        Enum.each plans, fn p -> delete(p["id"], key) end
      {:error, err} -> raise err
    end
    {:ok}
  end
end
