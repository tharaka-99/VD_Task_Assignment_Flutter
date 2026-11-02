# Flutter Authentication Module

A production-ready Flutter authentication module built with **Clean Architecture (Feature-First)**, **Provider State Management**, and strict Dart null-safety standards.

---

## 🚀 Features

- **Login**:
  - Email or Mobile dual-mode identifier login.
  - Password field with local-state show/hide visibility toggle.
- **Registration**:
  - Full Name, Email, Mobile Number, Password, and Password Confirmation fields.
  - Validates on interaction and submit.
  - On registration success, displays a success snackbar and navigates back to Login.
- **Forgot Password**:
  - Email or Mobile identification input.
  - Simulates sending a password reset instructions link with loading & success/error feedback.
- **Dashboard / Home**:
  - Displays authenticated user profile information (Name, Email, Mobile, ID).
  - Secure logout clearing navigation stack and session.

---

## 🔑  Test Credentials

The application uses an in-memory mock remote data source simulating network responses.

### Pre-seeded Credentials
- **Email**: `test@example.com`
- **Mobile Number**: `0771234567`
- **Password**: `Test@1234`
*(You can sign in using either the email or the mobile number!)*

---

## 🔍 Validation Rules

| Field | Rule |
|---|---|
| **Name** | At least 3 characters, letters and spaces only. |
| **Email** | Standard RFC 5322 regex validation. |
| **Mobile** | 9 to 15 digits with optional leading `+`. |
| **Password** | Min 8 characters with at least 1 uppercase, 1 lowercase, and 1 digit. |
| **Confirm Password** | Must strictly match the password field. |
| **Login Identifier** | Validated as either a valid email address OR a valid mobile number. |

---

