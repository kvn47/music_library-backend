module Album::Contract
  class Import < BaseContract
    validation do
      required(:albums).filled
    end
  end
end