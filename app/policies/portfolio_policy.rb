class PortfolioPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    permitted_action?
  end

  def edit?
    permitted_action?
  end

  def show
    true
  end

  def updated?
    edit?
  end

  def destroy?
    permitted_action?
  end

  private

    def permitted_action?
      record.user == user
    end

    class Scope < Scope
      def resolve
        user.portfolios
      end
    end
end
