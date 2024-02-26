class UserPassword < ApplicationRecord
  # Owner is the user who created the password, can view, edit, share, delete
  # Viewer can view the password
  # Editor can view and edit the password
  ROLES = %w[owner viewer editor].freeze

  belongs_to :user
  belongs_to :password

  validates :role, presence: true, inclusion: { in: ROLES }
  attribute :role, default: "viewer"

  def owner?
    role == "owner"
  end

  def viewer?
    role == "viewer"
  end

  def editor?
    role == "editor"
  end

  def editable?
    owner? || editor?
  end

  def shareable?
    owner?
  end
end
