class AddIndexesToPractitioners < ActiveRecord::Migration[5.2]
  def change
    add_index(:practitioners, :first_name)
    add_index(:practitioners, :last_name)
  end
end
