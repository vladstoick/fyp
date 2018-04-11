# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  validates_inclusion_of :role, in: %w[admin student]

  has_many :submissions, class_name: 'Submission', dependent: :destroy
  has_many :challenges, class_name: 'Challenge', dependent: :destroy

  def admin?
    role == 'admin'
  end
end
