# Password Change API Implementation

Implement the backend API endpoint for password change functionality in the customer account section. Currently marked as TODO in account.html.twig.

## Rationale
Users cannot currently change their passwords through the account interface, which is a basic security and UX requirement. This addresses a known gap identified in the codebase.

## User Stories
- As a customer, I want to change my password so that I can maintain account security

## Acceptance Criteria
- [ ] Users can change their password from the account settings page
- [ ] Password validation includes current password verification
- [ ] Strong password requirements are enforced (min 8 chars, mixed case, numbers)
- [ ] Success/error messages display appropriately
- [ ] Session remains valid after password change
