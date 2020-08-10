module Import
  class PurchaseCallback
    def on_complete(status, options)
      if status.failures.zero?
        import_purchase = Import::Purchase.find(
          options['import_purchase_id']
        )

        if import_purchase.lines.failed.any?
          import_purchase.complete_with_errors!
        else
          import_purchase.complete!
        end
      else
        raise Import::ProcessFail, options['import_purchase_id']
      end
    end
  end
end
