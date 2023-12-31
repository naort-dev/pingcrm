require 'active_support/concern'

module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :not_trashed, -> { where(deleted_at: nil) }
    scope :only_trashed, -> { where.not(deleted_at: nil) }
    scope :with_trashed, -> { all }

    scope :trash_filter,
          ->(name) {
            case name
            when 'with'
              with_trashed
            when 'only'
              only_trashed
            else
              not_trashed
            end
          }
  end

  def soft_delete
    update deleted_at: Time.current
  end

  def soft_delete!
    update! deleted_at: Time.current
  end

  def restore
    update deleted_at: nil
  end

  def restore!
    update! deleted_at: nil
  end
end
