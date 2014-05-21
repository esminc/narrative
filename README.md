[![Build Status](https://travis-ci.org/esminc/narrative.svg?branch=master)](https://travis-ci.org/esminc/narrative)
[![Code Climate](https://codeclimate.com/github/esminc/narrative.png)](https://codeclimate.com/github/esminc/narrative)

# Narrative

A simple implementation of DCI.

## Installation

Add this line to your application's Gemfile:

    gem 'narrative'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install narrative

## Usage

usecase: send money from sender's account to receiver's.

### data (BankAccount)

```ruby
class BankAccount
  attr_reader :account_id, :balance

  def initialize(account_id, balance = 0)
    @account_id = account_id
    @balance = balance
  end

  def increase!(money)
    @balance += money
  end

  def decrease!(money)
    @balance -= money
  end
end
```

### define the roles and its interaction.

```ruby
class TransferAccount
  include Narrative::Scene

  principal :sender, partners: %i(receiver) do
    def send!(money)
      verify_balance! money

      receiver.receive! money
      decrease! money
    end

    private

    def verify_balance!(money)
      raise 'error!' if balance - money < 0
    end
  end

  role :receiver do
    def receive!(money)
      increase! money
    end
  end
end
```

Interaction should have one principal role which is the main role of the scene.

A role can refer to other roles defined in `partners:`.

In above example, principal role `sender` can refer to `receiver` instance.


The usage of this interaction describe below:

```ruby
describe TransferAccount do
  describe 'send money to receiver' do
    let(:from_account_balance) { 20_000 }
    let(:to_account_balance) { 0 }

    let(:from_account) { BankAccount.new('from', from_account_balance) }
    let(:to_account) { BankAccount.new('to', to_account_balance) }

    context 'send $5_000 to receiver' do
      let(:money) { 5_000 }

      subject(:transfer) do
        # bind `from_account` to `sender`, and `to_account` to `receiver`
        TransferAccount.new(sender: from_account, receiver: to_account).perform do |sender|
          sender.send! money
        end
      end

      it { expect { transfer }.to change(from_account, :balance).from(from_account_balance).to(from_account_balance - money) }
      it { expect { transfer }.to change(to_account, :balance).from(to_account_balance).to(to_account_balance + money) }
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
