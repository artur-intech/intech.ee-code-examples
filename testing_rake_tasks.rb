# frozen_string_literal: true

require 'rake'
require 'minitest/autorun'

# Load rake tasks from `rakelib` dir
rake_app = Rake::Application.new
rake_app.load_rakefile

# An entity from our imaginary CRM system. Fake object for demo purposes.
class Invoice
  def cancelled?
    true
  end

  def id
    1234
  end
end

class CancelOverdueInvoicesTaskTest < Minitest::Test
  def test_cancels_overdue_invoice
    invoice = overdue_invoice

    capture_io do
      run_task
    end

    assert invoice.cancelled?
  end

  def test_output
    invoice = overdue_invoice

    assert_output "Invoice ##{invoice.id} has been cancelled\nCancelled total: 1\n" do
      run_task
    end
  end

  # I tend to keep all test utility methods (http://xunitpatterns.com/Test%20Utility%20Method.html) private to make them
  # more prominent, but it actually doesn't matter at all since all objects derived from `Minitest::Test` are not proper
  # objects in terms of object thinking and serve purely as containers for test methods.
  private

  # Creation method
  def overdue_invoice
    Invoice.new
  end

  def run_task
    Rake::Task['cancel_overdue_invoices'].execute
  end
end
