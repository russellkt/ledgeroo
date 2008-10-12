CREATE TABLE `account_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `is_debit` tinyint(1) default '0',
  `is_credit` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `account_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `account_group_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `accounting_entries` (
  `id` int(11) NOT NULL auto_increment,
  `accounting_transaction_id` bigint(11) default NULL,
  `account_id` bigint(11) default NULL,
  `debit` decimal(10,2) default NULL,
  `credit` decimal(10,2) default NULL,
  `memo` varchar(255) default NULL,
  `has_cleared` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `accountable_id` bigint(11) default NULL,
  `accountable_type` varchar(255) default NULL,
  `statement_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `accounting_transactions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `document_id` bigint(11) default NULL,
  `document_number` bigint(11) default NULL,
  `memo` varchar(255) default NULL,
  `recorded_on` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `transaction_type` varchar(255) default NULL,
  `is_void` tinyint(1) default '0',
  `department_id` bigint(11) default NULL,
  `class_id` bigint(11) default NULL,
  `location_id` bigint(11) default NULL,
  `accountable_type` varchar(255) default NULL,
  `accountable_id` bigint(11) default NULL,
  `reversal_id` bigint(11) default NULL,
  `batch_id` bigint(11) default NULL,
  `total` decimal(10,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  `description` text,
  `account_type_id` bigint(11) default NULL,
  `number` text,
  `bank_number` text,
  `is_inactive` tinyint(1) default '0',
  `parent_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `company_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `batch_imports` (
  `id` int(11) NOT NULL auto_increment,
  `batch_id` int(11) default NULL,
  `accountable_id` int(11) default NULL,
  `accountable_type` varchar(255) default NULL,
  `document_number` varchar(255) default NULL,
  `recorded_on` date default NULL,
  `payee` varchar(255) default NULL,
  `account_number` varchar(255) default NULL,
  `amount` decimal(10,2) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `batches` (
  `id` int(11) NOT NULL auto_increment,
  `date` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `finalized` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `authorizable_type` varchar(40) default NULL,
  `authorizable_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles_users` (
  `user_id` bigint(11) default NULL,
  `role_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `statements` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` bigint(11) default NULL,
  `started_on` date default NULL,
  `ended_on` date default NULL,
  `beginning_balance` decimal(10,2) default NULL,
  `ending_balance` decimal(10,2) default NULL,
  `is_closed` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `state` varchar(255) default 'passive',
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20080813125723');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');