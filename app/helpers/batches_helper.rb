module BatchesHelper
  def visit_batch_check batch, check
    if batch.finalized?
      batch_check_path(batch, check)
    else
      edit_batch_check_path(batch, check)
    end
  end
end
