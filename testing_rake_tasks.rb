# frozen_string_literal: true

require 'rake'
require 'minitest/autorun'

rake_app = Rake::Application.new
rake_app.load_rakefile

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

  private

  def overdue_invoice
    Invoice.new
  end

  def run_task
    Rake::Task['cancel_overdue_invoices'].execute
  end
end
