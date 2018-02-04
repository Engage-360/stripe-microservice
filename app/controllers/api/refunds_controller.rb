class API::RefundsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_access_control_headers

  def create
    refund = Refund.new(refund_params)
    if refund.save!
      createRefund(refund)
      render json: refund, status: :created
    else
      render json: {errors: refund.errors}, status: :unprocessable_entity
    end
  end

  private

  def refund_params
    params.require(:refund).permit(:charge_id, :amount, :reason)
  end

  def createRefund(refund)
    Stripe::Refund.create(
      charge: refund.charge_id,
      amount: refund.amount,
      reason: refund.reason
    )
  end
end
