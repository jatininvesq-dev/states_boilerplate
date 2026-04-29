class EndPoints {
  /// Standard user login (relative to API base URL).
  static const String login = "login";

  /// Owner login when "Login with owner" is enabled.
  static const String adminLogin = "admin/login";

  //reset password
  static const String forgotPassword = "forgot-password";
  static const String resetPassword = "reset-password";

  static const String logout = "logout";

  static const String userProfile = "contact/profile";
  static const String setting = "settings";
  static const String localization = "localization-option";

  /// Clients Endpoints
  static const String clientList = "customer";
  static const String customerOption = "customer-options";
  static const String createClient = "customer";
  static const String deleteClient = "customer/"; // expects id
  static const String clientListByFilter = "customer-filter";
  static const String clientNotes = "list-customer-notes-id/";
  static const String addClientNote = "add-customer-notes";
  static const String deleteClientNote = "notes/"; //expects id
  static const String updateClientNote = "update-customer-notes";
  static const String addClientReminder = "add-customer-reminders";
  static const String updateClientRemider = "update-customer-reminders";
  static const String deletClientReminder = "reminders/"; //expects id
  static const String clientReminderList = "list-customer-reminders-id/";
  static const String clientActivityOption = "customer-activity-logs-option";
  static const String activityLists = "list-customer-activity-logs-id/";
  static const String activityLogsFilter =
      "customer-activity-logs-filter/"; // expects rel_id appended
  static const String addClientAttechment = "add-customer-attachments";
  static const String updateClientAttechment =
      "update-customer-attachments/"; //expects id
  static const String clientAttachmentList =
      "list-customer-attachments-id/"; // expects rel_id appended
  static const String deleteClientAttechment = "attachments/"; //expects id
  static const String clientContactList =
      "customer-contacts-id/"; //expects rel_id
  static const String addClientContact = "customer-contacts";

  //-----
  static const String clientTaskList = "list-customer-tasks-id/";
  //options
  static const String relationTypeOptions = "relation-types";
  static const String tasksOptions = "tasks-option";
  static const String releatedOtpion = "related-options?rel_type=customer";
  //
  static const String addClientTask = "tasks";
  static const String updateClientTask = "tasks/"; // expects id
  static const String deleteClientTask = "tasks/"; //expects id

  //User managemennt
  static const String userManagementList = "client-users";
  static const String usersPermissionList = "roles-permissions";
  static const String createUser = "client-users";

  //Invoice
  static const String invoiceList = "crm-invoices";
  static const String invoiceOptionsList = "crm-invoices-option";
  static const String invoiceFilterList = "crm-invoices-filter";
  static const String invoiceDataDetails = "crm-invoices-show";
  static const String invoiceDeleteById = "crm-invoices/"; //expects id
  static const String updateInvoiceDetailsById = "crm-invoices/"; //expects id
  static const String invoiceAllDetailsById = "crm-invoices-view-id/";

  static const String storePayment = "invoice-payment-store";

  //operations
  //------Invoice Notes------
  static const String listOfInvoiceNots =
      "list-invoice-notes-id/"; // expects id appended
  static const String addInvoiceNote = "add-invoice-notes";
  static const String updateInvoiceNote = "update-invoice-notes/"; //expects id
  static const String deleteInvoiceNote = "notes/"; //expects id
  //------Invoice Reminders------
  static const String listOfInvoiceReminders =
      "list-invoice-reminders-id/"; // expects id appended
  static const String addInvoiceReminder = "add-invoice-reminders";
  static const String updateInvoiceReminder =
      "update-invoice-reminders/"; // expects id
  static const String deleteInvoiceReminder = "reminders/"; //expects id
  //------Invoice Attachments------
  static const String listOfInvoiceAttachments =
      "list-invoice-attachments-id/"; // expects id appended
  static const String addInvoiceAttachment = "add-invoice-attachments";
  static const String updateInvoiceAttachment =
      "update-invoice-attachments/"; // expects id
  static const String deleteInvoiceAttachment = "attachments/"; //expects id
  //------Invoice Activities------
  static const String invoiceActivityOptions = "invoice-activity-logs-option";

  static const String listOfInvoiceActivities =
      "list-invoice-activity-logs-id/"; // expects id appended

  static const String deleteInvoiceActivity = "activities/"; //expects
  //------Invoice Tasks------
  static const String listOfInvoiceTasks =
      "list-invoice-tasks-id/"; // expects id appended
  static const String addInvoiceTask = "tasks";
  static const String updateInvoiceTask = "tasks/"; // expects id
  static const String deleteInvoiceTask = "tasks/"; //expects id

  //Product item
  static const String productItemList = "items";
  static const String updateItemDetailsById = "items/"; //expects id
  static const String deleteItemById = "items/"; //expects id

  /// Expense Endpoints
  static const String expenseOptionsList = "expenses-option";
  static const String expenseDetails = "expenses-show/"; //expects id
  static const String expenseList = "expenses";
  static const String extractReceiptOcr = "ocr";
  static const String deleteExpense = "expenses/"; //expects id

  ///Expense operations
  static const String expenseReminderList =
      "list-expense-reminders-id/"; //expects id appended
  static const String createExpenseReminder = "add-expense-reminders";
  static const String updateExpenseReminder =
      "update-expense-reminders/"; //expects id appended
  static const String deleteExpenseReminder = "reminders/";
  static const String expenseActivityLogsOptions =
      "expense-activity-logs-option";

  //
  static const String expenseTaskList =
      "list-expense-tasks-id/"; //expects id appended
  static const String addExpenseTask = "tasks";
  static const String updateExpenseTask = "tasks/"; //expects id appended
  static const String deleteExpenseTask = "tasks/"; //expects id appended

  //
  static const String expenseActivityLogList =
      "list-expense-activity-logs-id/"; //expects id appended

  //Estimate endpoints
  static const String estimateList = "crm-estimates";
  static const String estimateListByFilter = "crm-estimates-filter";
  static const String estimateOptions = "crm-estimates-option";
  static const String estimateFilterOptions = "crm-estimates-filter-option";
  static const String createEstimate = "crm-estimates";
  static const String deleteEstimate = "crm-estimates/"; //expects id

  ///Estimate operations
  ///
  static const String estimateDetailsById = "crm-estimates-view-id/";
  static const String updateEstimateDetails = "crm-estimates/"; //expects id
  static const String estimateDataDetails = "crm-estimates-show/";

  ///------Estimate Notes------
  static const String estimateNotesList =
      "list-estimate-notes-id/"; //expects id appended
  static const String addEstimateNote = "add-estimate-notes";
  static const String updateEstimateNote =
      "update-estimate-notes/"; //expects id
  static const String deleteEstimateNote = "notes/"; //expects id
  ///------Estimate Tasks------
  static const String estimateTaskList =
      "list-estimate-tasks-id/"; //expect id appended
  static const String addEstimateTask = "tasks";
  static const String updateEstimateTask = "tasks/"; //expects id
  static const String deleteEstimatedTask = "tasks/";

  ///------Estimate Reminders---
  static const String estimateReminderList =
      "list-estimate-reminders-id/"; //expects id appended
  static const String addEstimateReminder = "add-estimate-reminders";
  static const String updateEstimateReminder =
      "update-estimate-reminders/"; //expects id
  static const String deleteEstimateReminder = "reminders/"; //expects id

  ///------Estimate Attechments------
  static const String estimateAttachmentList =
      "list-estimate-attachments-id/"; //expect id appended
  static const String addEstimateAttachment = "add-estimate-attachments";
  static const String updateEstimateAttachment =
      "update-estimate-attachments/"; //expect id
  static const String deleteEstimateAttachment = "attachments/"; //expects id

  ///------Estimate Activities------
  static const String estimateActivityLogOptions =
      "estimate-activity-logs-option";
  static const String estimateActivityLogList =
      "list-estimate-activity-logs-id/"; //expect id appended
  //

  ///Home Endpoints
  static const String usersMainPermission = "permissions";

  ///Company Module endpoints
  static const String companyDetails = "crmclients";
  static const String updateCompanyDetails = "crmclients";
  static const String updateCompanyPaymentDetails = "update-payment-details";

  ///company operations endpoints
  ////-----Taxes operations------
  static const String taxesList = "tax-rates";
  static const String creatTaxes = "tax-rates";
  static const String updateTaxeById = "tax-rates/";
  static const String deleteTaxesById = "tax-rates/";
  ////------Currencies operations----
  static const String currenciesList = "currencies";
  static const String createCurrency = "currencies";
  static const String updateCurrencyById = "currencies/";
  static const String deleteCurrencyById = "currencies/";
  ////------Payment operations ------
  static const String paymentList =
      "payments?per_page=10&page=1&sortBy=id&sortDirection=desc"; // //payment-data
  static const String createPayment = "payments";
  static const String updatePaymentById = "payments/";
  static const String deletePaymentById = "payments/";
  ////------ Company settings endpoints----
  static const String companySettingDetails = "settings";

  ///General Tasks endpoints
  static const String getGeneralTasks = "tasks";
  static const String getGeneralTasksByFilter = "tasks-filter";
  static const String getRelationTypeList = "relation-types";
  static const String getTasksFilterOptions = "tasks-filter-option";
  static const String getRelatedOptionsByType = "related-options";
  static const String createGeneralTask = "tasks";
  static const String updateGeneralTask = "tasks/"; // expects id
  static const String deleteGeneralTask = "tasks/"; //expects id

  ////Common Payments module endpoints
  static const String getAllPaymentList = "payment-data";

  ///General Notes module endpoints
  static const String getAllGeneralNotes = "notes";
  static const String getGeneralNotesByFilter = "notes-filter";
  static const String createGeneralNote = "notes";
  static const String updateGeneralNote = "notes/"; //expects id
  static const String deleteGeneralNote = "notes/"; //expects id

  ///General Attechment module endpoints
  static const String getAllGeneralAttechments = "attachments";
  static const String getGeneralAttechmentsByFilter = "attachments-filter";
  static const String createGeneralAttechment = "attachments";
  static const String updateGeneralAttechmentById = "attachments/"; //expects id
  static const String deleteGeneralAttechmentById = "attachments/"; //expects id

  ////General Reminder module endpoints
  static const String getAllGeneralReminders = "reminders";
  static const String getGeneralRemindersByFilter = "reminders-filter";
  static const String getReminderFilterOption = "reminders-option";
  static const String createGeneralReminder = "reminders";
  static const String updateGeneralReminderById = "reminders/"; //expects id
  static const String deleteGeneralReminderById = "reminders/"; //expects id

  ///Global Search endpoints
  static const String globalSearch = "global-search";

  ///Calendar endpoints
  static const String getCalendarList = "calendar-events";

  ///Notification endpoints
  /// GET `unread` with query `client_id` ([ManageUsersListModel.clientId]).
  static const String getUnreadNotificationsList = "notifications/unread";
  static const String readAllNotifications = "notifications/read-all";
  static const String readNotification = "notifications/read";

  ///load PDF base URL
  static const String loadInvoicePdfBaseUrl =
      "https://invesqcrm.rundfunkbeitragservice.com/sales-invoice/";
  static const String loadEstimatePdfBaseUrl =
      "https://invesqcrm.rundfunkbeitragservice.com/sales-estimate/";

  ///Fot google id regiater
  static const String connectGoogleId = "mobile/email/auth/accesstoken";

  //curency  filter
  static const String getFilterInvoiceByCurrency = "crm-invoices-filter";

  static const String getFilterEstimateByCurrency = "crm-estimates-filter";
}
