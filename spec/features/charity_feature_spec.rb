require 'rails_helper'
require_relative 'charity_helper'

include CharityHelper

feature 'charities:' do

	context 'charity not signed up/in on the homepage' do

		scenario 'should see a charity button' do
			visit '/'
			expect(page).to have_link 'Charity'
		end

		scenario 'should be able to sign-up/in' do
			visit '/'
			click_link 'Charity'
			expect(page).to have_link 'Sign In'
			expect(page).to have_link 'Sign Up'
			expect(page).not_to have_link 'Sign Out'
		end

		scenario 'can do that' do
			visit '/charity'
			sign_up
			expect(current_path).to eq '/charity'
			expect(page).to have_content 'Crisis'
		end

		scenario 'when signing up they add donor requirements' do
			visit '/charity'
			click_link 'Sign Up'
			fill_in 'Organisation', with: 'Crisis'
			fill_in 'Description', with: 'We are crisis and we help the homeless'
			fill_in 'Contact name', with: 'contact'
			fill_in 'Email', with: 'contact@email.com'
			fill_in 'Full address', with: 'i live here'
			fill_in 'Postcode', with: 'SW15 7HH'
			fill_in 'Password', with: 'testtest'
			fill_in 'Password confirmation', with: 'testtest'
			page.check('Tins')
			click_button 'Sign Up'
		end

	end

	context 'charity signed up/in and' do 

		before do
			sign_up
		end

		scenario 'should see sign out link' do
			visit '/charity'
			expect(page).to have_link 'Sign Out'
			expect(page).not_to have_link 'Sign In'
			expect(page).not_to have_link 'Sign Up' 
		end

	end

	context 'charities created but not logged in' do

		scenario 'should see list of all the charities' do
			sign_up
			click_link 'Sign Out'
			visit '/charity'
			expect(page).to have_content 'All Charities'
			expect(page).to have_content 'Crisis'
			expect(page).to have_content 'We are crisis and we help the homeless'
		end

	end

	context 'charity is signed in and they' do

		before do
			sign_up
		end

		scenario 'should see their own profile' do
			expect(current_path).to eq '/charity'
			expect(page).to have_content 'My Profile'
			expect(page).to have_content 'Crisis'
		end

		scenario 'should be able to delete their own profile' do
			expect(page).to have_content 'Crisis'
			expect(page).to have_link 'Edit'
			click_link 'Edit'
			expect(page).to have_content 'Edit Charity'
			expect(page).to have_button 'Remove Charity'
			click_button 'Remove Charity'
			expect(page).to have_content 'Bye! Your account has been successfully cancelled. We hope to see you again soon.'
		end

		scenario 'should be able to edit their own profile' do
			click_link 'Edit'
			expect(page).to have_content 'Organisation'
			expect(page).to have_content 'Description'
			fill_in 'Organisation', with: 'ChocAid'
			fill_in 'Description', with: 'We are ChocAid and we help the homeless with chocolate'
			fill_in 'Current password', with: 'testtest'
			click_button 'Update'
			visit '/charity'
			expect(page).to have_content 'ChocAid'
			expect(page).not_to have_content 'Crisis'
		end

	end

end