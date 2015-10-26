Active Shipping
===============

This is a Solidus extension that wraps the popular [active_shipping](http://github.com/Shopify/active_shipping/tree/master) plugin.

Installation
------------

**1.** Add the gem to your application's Gemfile:

We highly recommend using the stable branches of this gem. If you were using version 1.3, you can place this line inside your application's Gemfile:

```ruby
gem 'solidus_active_shipping', github: 'pervino/solidus_active_shipping'
```

**2.** Install migrations and migrate database:

```
$ bundle exec rake railties:install:migrations
$ bundle exec rake db:migrate
```

**3.** Run bundler:

```
$ bundle
```

Rate quotes from carriers
---

So far, this gem supports getting quotes from UPS, USPS, Canada Post, and FedEx. In general, you will need a developer account to get rates. Please contact the shipping vendor that you wish to use about generating a developer account.

Once you have an account, you can go to the active shipping settings admin configuration screen to set the right fields. You need to set all of the Origin Address fields and the fields for the carrier you wish to use. To set the settings through a config file, you can assign values to the settings like so:

```ruby
Spree::ActiveShipping::Config[:ups_login]
Spree::ActiveShipping::Config[:ups_password]
Spree::ActiveShipping::Config[:ups_key]
Spree::ActiveShipping::Config[:usps_login]
```

**NOTE:** When setting up FedEx credentials, `:fedex_login` is the "Meter Number" that FedEx supplies you with.

It is important to note how this wrapper matches the calculators to the services available from the carrier API's, by default the base calculator matches the service name to the calculator class and returns the rate, this magic happens as follows:

1. inside the calculator class
```ruby
Spree::Calculator::Shipping::Fedex::GroundHomeDelivery::description #holds the service name
```

2. inside the calculator base
```ruby
  rates_result = retrieve_rates_from_cache(package, origin, destination) # <- holds the rates for given package in a parsed hash (see sample response below)
  rate = rates_result[self.class.description] # <- matches with the description as the key
```

this means that the calculator **Fedex::GroundHomeDelivery** will hit FedEx Servers and try to get the rates for the given package, since FedEx returns rates for package and returns all of its available services for the given shipment we need to identify which service we are targeting ( see caching results below ) the calculator will only pick the rates from a service that matches the **"FedEx Ground Home Delivery"** string, you can see how it works below:

a sample rate response already parsed looks like this:
```ruby
{
         "FedEx First Overnight" => 5886,
      "FedEx Priority Overnight" => 2924,
      "FedEx Standard Overnight" => 2529,
                "FedEx 2 Day Am" => 1987,
                   "FedEx 2 Day" => 1774,
    "FedEx Ground Home Delivery" => 925
}
```

the rate hash that is parsed by the calculator has service descriptions as keys, this makes it easier to get the rates you need.

3. getting the rates (all the above together)
```ruby
  calculator = Solidus::Calculator::Shipping::Fedex::GroundHomeDelivery.new
  calculator.description # "FedEx Ground Home Delivery"
  rate = calculator.compute(<Package>)
  rate # $9.25
```

you can see the rates are given in cents from FedEx (in the rate hash example above), ```solidus_active_shipping``` converts them dividing them by 100 before sending them to you

**Note:** if you want to integrate to a new carrier service that is not listed below please take care when trying to match the service name key to theirs, there are times when they create dynamic naming conventions, please take as an example **USPS**, you can see the implementation of USPS has the **compute_packages** method overridden to match against a **service_code** key that had to be added to calculator services ( Issue #103 )

Global Handling Fee
-------------------

```ruby
Spree::ActiveShipping::Config[:handling_fee]
```

This property allows you to set a global handling fee that will be added to all calculated shipping rates.  Specify the number of cents, not dollars. You can either set it manually or through the admin interface.

Weights
---------------------

## Global weight default
This property allows you to set a default weight that will be substituted for products lacking defined weights. You can either set it manually or through the admin interface.

```ruby
Spree::ActiveShipping::Config[:default_weight]
```

## Weight units
Weights are expected globally inside ```solidus_active_shipping``` to be entered in a unit that can be divided to oz and a global variable was added to help with unit conversion

```ruby
Spree::ActiveShipping::Config[:unit_multiplier]
```

It is important to note that by default this variable is set to have a value of **16** expecting weights to be entered in **lbs**

### Example of converting from metric system to oz

Say you have your weights in **kg** you would have to set the multiplier to **0.0283495**

```ruby
Spree::ActiveShipping::Config[:unit_multiplier] = 0.0283495
```