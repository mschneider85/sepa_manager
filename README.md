# SEPA Manager

![Build passing](https://github.com/mschneider85/sepa_manager/actions/workflows/rubyonrails.yml/badge.svg)

## Overview

SEPA Manager is a Ruby on Rails application tailored for managing SEPA (Single Euro Payments Area) direct debit transactions. This comprehensive tool not only enables users to input and manage transactions efficiently but also provides a seamless export functionality for generating SEPA direct debit XML files. Additionally, the application comes equipped with a robust authentication system and global settings for creditor information.

## Features

:notebook: ***Authentication***
  - Securely manage user access with a built-in authentication system. Users can sign up, log in, and perform actions based on their assigned roles.

:wrench: ***Creditor Settings***
  - Set and manage global creditor information that are applied uniformly to all transactions.

:family: ***Members***
  - Manage member information including name, address, and banking details. Members can be associated with transactions for efficient data entry and management.

:money_with_wings: ***Transaction Creation from Member Data***
  - Create transactions directly from member data, reducing the need for manual data entry and minimizing errors. This service allows for efficient creation of multiple transactions.

:page_facing_up: ***Transaction Input***
  - Easily input SEPA direct debit transactions with detailed information, including debtor details, transaction amounts, due dates, and more.

:page_facing_up: ***Transaction Listing***
  - Access a comprehensive list of all entered SEPA transactions.

:outbox_tray: ***SEPA XML Export***
  - Generate SEPA XML files adhering to the required standards for direct debit transactions. The exported files can seamlessly integrate with banking systems and financial tools.

## Configuration

- `RAILS_HOST`: The host name that the application uses. This is typically the domain name of your application when deployed.

The application uses SMTP for sending emails. The SMTP settings are configured via environment variables. Here are the environment variables used:

- `SMTP_ADDRESS`: The address of the SMTP server.
- `SMTP_PORT`: The port to use for the SMTP server. Default is `587`.
- `SMTP_DOMAIN`: The HELO domain provided by the client to the server.
- `SMTP_USER_NAME`: The username to use for SMTP authentication.
- `SMTP_PASSWORD`: The password to use for SMTP authentication.
- `SMTP_AUTHENTICATION`: The authentication type to use. Default is `plain`.
- `SMTP_ENABLE_STARTTLS_AUTO`: Whether to use STARTTLS. Default is `true`.

In addition, the sender email address for Devise emails is configured via the `DEVISE_MAILER_SENDER` environment variable:

- `DEVISE_MAILER_SENDER`: The sender email address for Devise emails.

You can set these environment variables in your `.env` file.

## License

This project is licensed under the [MIT License](LICENSE.md).
