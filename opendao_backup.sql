-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: opendao_local
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
INSERT INTO `_prisma_migrations` VALUES ('47aab353-a866-4c16-94d3-af0c3e92c7f3','bdbf13635a37193ebcf0a89329178b517922bd2979d1b0cc02f5cd6ff0fef4e6','2025-09-06 17:46:59.999','20250906174651_init',NULL,NULL,'2025-09-06 17:46:51.965',1);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `providerAccountId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `refresh_token` text COLLATE utf8mb4_unicode_ci,
  `access_token` text COLLATE utf8mb4_unicode_ci,
  `expires_at` int DEFAULT NULL,
  `token_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scope` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_token` text COLLATE utf8mb4_unicode_ci,
  `session_state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Account_provider_providerAccountId_key` (`provider`,`providerAccountId`),
  KEY `Account_userId_idx` (`userId`),
  CONSTRAINT `Account_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blockedemail`
--

DROP TABLE IF EXISTS `blockedemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blockedemail` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `BlockedEmail_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blockedemail`
--

LOCK TABLES `blockedemail` WRITE;
/*!40000 ALTER TABLE `blockedemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `blockedemail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bounties`
--

DROP TABLE IF EXISTS `bounties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bounties` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `deadline` datetime(3) DEFAULT NULL,
  `commitmentDate` datetime(3) DEFAULT NULL,
  `eligibility` json DEFAULT NULL,
  `status` enum('OPEN','REVIEW','CLOSED','VERIFYING','VERIFY_FAIL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rewardAmount` double DEFAULT NULL,
  `rewards` json DEFAULT NULL,
  `maxBonusSpots` int NOT NULL DEFAULT '0',
  `usdValue` double DEFAULT NULL,
  `tokenUsdAtPublish` double DEFAULT NULL,
  `sponsorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pocId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` enum('NATIVE','IMPORT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NATIVE',
  `isPublished` tinyint(1) NOT NULL DEFAULT '0',
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `applicationLink` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `skills` json DEFAULT NULL,
  `type` enum('bounty','project','hackathon') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'bounty',
  `requirements` text COLLATE utf8mb4_unicode_ci,
  `isWinnersAnnounced` tinyint(1) NOT NULL DEFAULT '0',
  `templateId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Global',
  `pocSocials` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hackathonprize` tinyint(1) NOT NULL DEFAULT '0',
  `applicationType` enum('rolling','fixed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `timeToComplete` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `references` json DEFAULT NULL,
  `referredBy` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `publishedAt` datetime(3) DEFAULT NULL,
  `isPrivate` tinyint(1) NOT NULL DEFAULT '0',
  `hackathonId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `compensationType` enum('fixed','range','variable') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `maxRewardAsk` int DEFAULT NULL,
  `minRewardAsk` int DEFAULT NULL,
  `language` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shouldSendEmail` tinyint(1) NOT NULL DEFAULT '1',
  `isFndnPaying` tinyint(1) NOT NULL DEFAULT '0',
  `winnersAnnouncedAt` datetime(3) DEFAULT NULL,
  `discordMessageIds` json DEFAULT NULL,
  `ai` json DEFAULT NULL,
  `publishedBy` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Bounties_slug_key` (`slug`),
  KEY `Bounties_id_slug_idx` (`id`,`slug`),
  KEY `Bounties_sponsorId_idx` (`sponsorId`),
  KEY `Bounties_pocId_idx` (`pocId`),
  KEY `Bounties_templateId_idx` (`templateId`),
  KEY `Bounties_hackathonId_idx` (`hackathonId`),
  KEY `Bounties_isPublished_isPrivate_idx` (`isPublished`,`isPrivate`),
  KEY `Bounties_deadline_updatedAt_idx` (`deadline`,`updatedAt`),
  KEY `Bounties_isWinnersAnnounced_idx` (`isWinnersAnnounced`),
  KEY `Bounties_title_idx` (`title`),
  KEY `Bounties_deadline_asc_idx` (`deadline`),
  KEY `Bounties_deadline_desc_idx` (`deadline` DESC),
  KEY `Bounties_winnersAnnouncedAt_idx` (`winnersAnnouncedAt` DESC),
  KEY `Bounties_isFeatured_idx` (`isFeatured` DESC),
  KEY `Bounties_isPublished_isActive_isArchived_status_idx` (`isPublished`,`isActive`,`isArchived`,`status`),
  KEY `Bounties_isPublished_isActive_isArchived_isPrivate_status_idx` (`isPublished`,`isActive`,`isArchived`,`isPrivate`,`status`),
  KEY `Bounties_sponsorId_isArchived_isPublished_isActive_idx` (`sponsorId`,`isArchived`,`isPublished`,`isActive`),
  KEY `Bounties_isPublished_isActive_isPrivate_hackathonprize_idx` (`isPublished`,`isActive`,`isPrivate`,`hackathonprize`),
  KEY `Bounties_compensationType_usdValue_idx` (`compensationType`,`usdValue`),
  KEY `Bounties_compensationType_maxRewardAsk_idx` (`compensationType`,`maxRewardAsk`),
  KEY `Bounties_isWinnersAnnounced_isPublished_status_idx` (`isWinnersAnnounced`,`isPublished`,`status`),
  KEY `Bounties_region_isPublished_status_idx` (`region`,`isPublished`,`status`),
  KEY `Bounties_isPublished_isActive_isArchived_isPrivate_type_idx` (`isPublished`,`isActive`,`isArchived`,`isPrivate`,`type`),
  KEY `Bounties_deadline_isWinnersAnnounced_idx` (`deadline`,`isWinnersAnnounced`),
  KEY `Bounties_usdValue_maxRewardAsk_idx` (`usdValue`,`maxRewardAsk`),
  KEY `Bounties_region_isPublished_isActive_idx` (`region`,`isPublished`,`isActive`),
  KEY `Bounties_sponsorId_isPublished_isActive_idx` (`sponsorId`,`isPublished`,`isActive`),
  KEY `Bounties_isFeatured_deadline_idx` (`isFeatured`,`deadline`),
  KEY `Bounties_createdAt_isPublished_idx` (`createdAt`,`isPublished`),
  KEY `Bounties_winnersAnnouncedAt_isWinnersAnnounced_idx` (`winnersAnnouncedAt`,`isWinnersAnnounced`),
  KEY `Bounties_language_compensationType_idx` (`language`,`compensationType`),
  KEY `Bounties_type_isPublished_isActive_isArchived_idx` (`type`,`isPublished`,`isActive`,`isArchived`),
  KEY `Bounties_isPublished_isActive_isArchived_isPrivate_hackathon_idx` (`isPublished`,`isActive`,`isArchived`,`isPrivate`,`hackathonprize`,`type`),
  KEY `Bounties_region_type_isPublished_isActive_idx` (`region`,`type`,`isPublished`,`isActive`),
  KEY `Bounties_deadline_isWinnersAnnounced_type_idx` (`deadline`,`isWinnersAnnounced`,`type`),
  CONSTRAINT `Bounties_hackathonId_fkey` FOREIGN KEY (`hackathonId`) REFERENCES `hackathon` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Bounties_pocId_fkey` FOREIGN KEY (`pocId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Bounties_sponsorId_fkey` FOREIGN KEY (`sponsorId`) REFERENCES `sponsors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Bounties_templateId_fkey` FOREIGN KEY (`templateId`) REFERENCES `bountiestemplates` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bounties`
--

LOCK TABLES `bounties` WRITE;
/*!40000 ALTER TABLE `bounties` DISABLE KEYS */;
/*!40000 ALTER TABLE `bounties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bountiestemplates`
--

DROP TABLE IF EXISTS `bountiestemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bountiestemplates` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deadline` datetime(3) DEFAULT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `color` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emoji` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `skills` json DEFAULT NULL,
  `type` enum('bounty','project','hackathon') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'bounty',
  `requirements` text COLLATE utf8mb4_unicode_ci,
  `region` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Global',
  `applicationType` enum('rolling','fixed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `status` enum('OPEN','REVIEW','CLOSED','VERIFYING','VERIFY_FAIL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `timeToComplete` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `references` json DEFAULT NULL,
  `referredBy` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `publishedAt` datetime(3) DEFAULT NULL,
  `compensationType` enum('fixed','range','variable') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `maxRewardAsk` int DEFAULT NULL,
  `minRewardAsk` int DEFAULT NULL,
  `language` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rewardAmount` double DEFAULT NULL,
  `rewards` json DEFAULT NULL,
  `maxBonusSpots` int NOT NULL DEFAULT '0',
  `usdValue` double DEFAULT NULL,
  `sponsorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pocId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pocSocials` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` enum('NATIVE','IMPORT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NATIVE',
  `isPublished` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `BountiesTemplates_isActive_isArchived_type_idx` (`isActive`,`isArchived`,`type`),
  KEY `BountiesTemplates_pocId_idx` (`pocId`),
  KEY `BountiesTemplates_sponsorId_idx` (`sponsorId`),
  KEY `BountiesTemplates_type_idx` (`type`),
  CONSTRAINT `BountiesTemplates_pocId_fkey` FOREIGN KEY (`pocId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `BountiesTemplates_sponsorId_fkey` FOREIGN KEY (`sponsorId`) REFERENCES `sponsors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bountiestemplates`
--

LOCK TABLES `bountiestemplates` WRITE;
/*!40000 ALTER TABLE `bountiestemplates` DISABLE KEYS */;
/*!40000 ALTER TABLE `bountiestemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(5000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `authorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `refType` enum('BOUNTY','SUBMISSION','GRANT_APPLICATION','POW') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BOUNTY',
  `refId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `isPinned` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `replyToId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submissionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('NORMAL','SUBMISSION','DEADLINE_EXTENSION','WINNER_ANNOUNCEMENT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NORMAL',
  PRIMARY KEY (`id`),
  KEY `Comment_id_refId_idx` (`id`,`refId`),
  KEY `Comment_authorId_idx` (`authorId`),
  KEY `Comment_replyToId_idx` (`replyToId`),
  KEY `Comment_refId_idx` (`refId`),
  KEY `Comment_refId_isActive_isArchived_type_idx` (`refId`,`isActive`,`isArchived`,`type`),
  KEY `Comment_refId_isActive_isArchived_replyToId_idx` (`refId`,`isActive`,`isArchived`,`replyToId`),
  KEY `Comment_refType_type_idx` (`refType`,`type`),
  KEY `Comment_updatedAt_idx` (`updatedAt` DESC),
  KEY `Comment_refId_isPinned_idx` (`refId`,`isPinned`),
  CONSTRAINT `Comment_authorId_fkey` FOREIGN KEY (`authorId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Comment_GrantApplication_fkey` FOREIGN KEY (`refId`) REFERENCES `grantapplication` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Comment_Listing_fkey` FOREIGN KEY (`refId`) REFERENCES `bounties` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Comment_PoW_fkey` FOREIGN KEY (`refId`) REFERENCES `pow` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Comment_replyToId_fkey` FOREIGN KEY (`replyToId`) REFERENCES `comment` (`id`),
  CONSTRAINT `Comment_Submission_fkey` FOREIGN KEY (`refId`) REFERENCES `submission` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditledger`
--

DROP TABLE IF EXISTS `creditledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creditledger` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `submissionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `applicationId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('SUBMISSION','SPAM_PENALTY','WIN_BONUS','MONTHLY_CREDIT','CREDIT_REFUND','GRANT_WIN_BONUS','GRANT_SPAM_PENALTY','SPAM_DISPUTE','GRANT_SPAM_DISPUTE','REFERRAL_FIRST_SUBMISSION_BONUS_INVITEE','REFERRAL_FIRST_SUBMISSION_BONUS_INVITER','REFERRAL_INVITEE_WIN_BONUS_INVITER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `change` int NOT NULL,
  `effectiveMonth` datetime(3) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `decision` enum('Pending','Approved','Rejected') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `CreditLedger_userId_idx` (`userId`),
  KEY `CreditLedger_submissionId_idx` (`submissionId`),
  KEY `CreditLedger_applicationId_idx` (`applicationId`),
  KEY `CreditLedger_effectiveMonth_idx` (`effectiveMonth`),
  CONSTRAINT `CreditLedger_applicationId_fkey` FOREIGN KEY (`applicationId`) REFERENCES `grantapplication` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `CreditLedger_submissionId_fkey` FOREIGN KEY (`submissionId`) REFERENCES `submission` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `CreditLedger_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditledger`
--

LOCK TABLES `creditledger` WRITE;
/*!40000 ALTER TABLE `creditledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `creditledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emaillogs`
--

DROP TABLE IF EXISTS `emaillogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emaillogs` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('BOUNTY_REVIEW','BOUNTY_DEADLINE','BOUNTY_DEADLINE_WEEK','BOUNTY_CLOSE_DEADLINE','BOUNTY_COMMITMENT_2DAYS','NO_VERIFICATION','NO_ACTIVITY','NO_REVIEW_SPONSOR_1','NO_REVIEW_SPONSOR_2','ROLLING_15_DAYS','ROLLING_30_DAYS','NEW_LISTING','ROLLING_UNPUBLISH','UNFILLED_PROFILE','WALLET_ANNOUNCEMENT','CREDITS_ANNOUNCEMENT','AUTO_GENERATE_ANNOUNCEMENT','NEW_LISTING_TELEGRAM','REFERRAL_ANNOUNCEMENT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `bountyId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `emailLogs_bountyId_type_idx` (`bountyId`,`type`),
  KEY `emailLogs_userId_type_idx` (`userId`,`type`),
  KEY `emailLogs_type_createdAt_idx` (`type`,`createdAt` DESC),
  KEY `emailLogs_email_type_idx` (`email`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emaillogs`
--

LOCK TABLES `emaillogs` WRITE;
/*!40000 ALTER TABLE `emaillogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `emaillogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailsettings`
--

DROP TABLE IF EXISTS `emailsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emailsettings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `EmailSettings_userId_category_idx` (`userId`,`category`),
  KEY `EmailSettings_userId_idx` (`userId`),
  KEY `EmailSettings_category_idx` (`category`),
  CONSTRAINT `EmailSettings_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailsettings`
--

LOCK TABLES `emailsettings` WRITE;
/*!40000 ALTER TABLE `emailsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grantapplication`
--

DROP TABLE IF EXISTS `grantapplication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grantapplication` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grantId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicationStatus` enum('Pending','Approved','Completed','Rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `projectTitle` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `projectOneLiner` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `projectDetails` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `projectTimeline` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `proofOfWork` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `walletAddress` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `twitter` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `github` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `milestones` text COLLATE utf8mb4_unicode_ci,
  `kpi` text COLLATE utf8mb4_unicode_ci,
  `answers` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `label` enum('Unreviewed','Reviewed','Shortlisted','Spam','Low_Quality','Mid_Quality','High_Quality','Pending','Inaccessible','Needs_Review') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `ask` double NOT NULL DEFAULT '0',
  `approvedAmount` double NOT NULL DEFAULT '0',
  `approvedAmountInUSD` double NOT NULL DEFAULT '0',
  `decidedAt` datetime(3) DEFAULT NULL,
  `totalPaid` double NOT NULL DEFAULT '0',
  `isShipped` tinyint(1) NOT NULL DEFAULT '0',
  `paymentDetails` json DEFAULT NULL,
  `totalTranches` int NOT NULL DEFAULT '0',
  `like` json DEFAULT NULL,
  `likeCount` int NOT NULL DEFAULT '0',
  `decidedBy` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ai` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `GrantApplication_userId_idx` (`userId`),
  KEY `GrantApplication_grantId_idx` (`grantId`),
  KEY `GrantApplication_likeCount_idx` (`likeCount`),
  KEY `GrantApplication_grantId_userId_applicationStatus_idx` (`grantId`,`userId`,`applicationStatus`),
  KEY `GrantApplication_applicationStatus_decidedAt_idx` (`applicationStatus`,`decidedAt`),
  KEY `GrantApplication_applicationStatus_createdAt_idx` (`applicationStatus`,`createdAt`),
  KEY `GrantApplication_userId_grantId_createdAt_idx` (`userId`,`grantId`,`createdAt`),
  KEY `GrantApplication_decidedAt_idx` (`decidedAt` DESC),
  KEY `GrantApplication_createdAt_idx` (`createdAt` DESC),
  KEY `GrantApplication_approvedAmountInUSD_idx` (`approvedAmountInUSD` DESC),
  CONSTRAINT `GrantApplication_grantId_fkey` FOREIGN KEY (`grantId`) REFERENCES `grants` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `GrantApplication_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grantapplication`
--

LOCK TABLES `grantapplication` WRITE;
/*!40000 ALTER TABLE `grantapplication` DISABLE KEYS */;
/*!40000 ALTER TABLE `grantapplication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grants`
--

DROP TABLE IF EXISTS `grants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grants` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `shortDescription` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `minReward` double DEFAULT NULL,
  `maxReward` double DEFAULT NULL,
  `totalPaid` double NOT NULL DEFAULT '0',
  `totalApproved` double NOT NULL DEFAULT '0',
  `historicalApplications` int NOT NULL DEFAULT '0',
  `historicalPaid` double NOT NULL DEFAULT '0',
  `link` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sponsorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pocId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isPublished` tinyint(1) NOT NULL DEFAULT '0',
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `skills` json DEFAULT NULL,
  `logo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Global',
  `questions` json DEFAULT NULL,
  `pocSocials` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('OPEN','CLOSED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `airtableId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avgResponseTime` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT '24h',
  `isNative` tinyint(1) NOT NULL DEFAULT '0',
  `isPrivate` tinyint(1) NOT NULL DEFAULT '0',
  `references` json DEFAULT NULL,
  `ai` json DEFAULT NULL,
  `approverRecordId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emailSender` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `replyToEmail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emailSalutation` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `communityLink` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Grants_slug_key` (`slug`),
  KEY `Grants_id_slug_idx` (`id`,`slug`),
  KEY `Grants_pocId_idx` (`pocId`),
  KEY `Grants_sponsorId_idx` (`sponsorId`),
  KEY `Grants_isPublished_isActive_isArchived_isPrivate_idx` (`isPublished`,`isActive`,`isArchived`,`isPrivate`),
  KEY `Grants_isPublished_isActive_isArchived_status_idx` (`isPublished`,`isActive`,`isArchived`,`status`),
  KEY `Grants_region_isPublished_isActive_idx` (`region`,`isPublished`,`isActive`),
  KEY `Grants_slug_idx` (`slug`),
  KEY `Grants_sponsorId_isActive_isArchived_status_idx` (`sponsorId`,`isActive`,`isArchived`,`status`),
  KEY `Grants_createdAt_idx` (`createdAt` DESC),
  KEY `Grants_totalApproved_idx` (`totalApproved` DESC),
  KEY `Grants_isPublished_isActive_isArchived_isPrivate_status_idx` (`isPublished`,`isActive`,`isArchived`,`isPrivate`,`status`),
  KEY `Grants_region_isPublished_isActive_isArchived_idx` (`region`,`isPublished`,`isActive`,`isArchived`),
  KEY `Grants_sponsorId_isPublished_isActive_isArchived_idx` (`sponsorId`,`isPublished`,`isActive`,`isArchived`),
  KEY `Grants_isFeatured_createdAt_idx` (`isFeatured`,`createdAt`),
  KEY `Grants_status_isPublished_isActive_idx` (`status`,`isPublished`,`isActive`),
  KEY `Grants_region_status_isPublished_idx` (`region`,`status`,`isPublished`),
  KEY `Grants_minReward_maxReward_idx` (`minReward`,`maxReward`),
  KEY `Grants_totalPaid_totalApproved_idx` (`totalPaid`,`totalApproved`),
  KEY `Grants_historicalApplications_totalApproved_idx` (`historicalApplications`,`totalApproved`),
  CONSTRAINT `Grants_pocId_fkey` FOREIGN KEY (`pocId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Grants_sponsorId_fkey` FOREIGN KEY (`sponsorId`) REFERENCES `sponsors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grants`
--

LOCK TABLES `grants` WRITE;
/*!40000 ALTER TABLE `grants` DISABLE KEYS */;
/*!40000 ALTER TABLE `grants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `granttranche`
--

DROP TABLE IF EXISTS `granttranche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `granttranche` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicationId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grantId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ask` double NOT NULL,
  `update` text COLLATE utf8mb4_unicode_ci,
  `helpWanted` text COLLATE utf8mb4_unicode_ci,
  `status` enum('Pending','Approved','Paid','Rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `approvedAmount` double DEFAULT NULL,
  `decidedAt` datetime(3) DEFAULT NULL,
  `trancheNumber` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `GrantTranche_applicationId_idx` (`applicationId`),
  KEY `GrantTranche_grantId_idx` (`grantId`),
  CONSTRAINT `GrantTranche_applicationId_fkey` FOREIGN KEY (`applicationId`) REFERENCES `grantapplication` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `GrantTranche_grantId_fkey` FOREIGN KEY (`grantId`) REFERENCES `grants` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `granttranche`
--

LOCK TABLES `granttranche` WRITE;
/*!40000 ALTER TABLE `granttranche` DISABLE KEYS */;
/*!40000 ALTER TABLE `granttranche` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hackathon`
--

DROP TABLE IF EXISTS `hackathon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hackathon` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sponsorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deadline` datetime(3) DEFAULT NULL,
  `startDate` datetime(3) DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `altLogo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `announceDate` datetime(3) DEFAULT NULL,
  `eligibility` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Hackathon_slug_key` (`slug`),
  UNIQUE KEY `Hackathon_sponsorId_key` (`sponsorId`),
  CONSTRAINT `Hackathon_sponsorId_fkey` FOREIGN KEY (`sponsorId`) REFERENCES `sponsors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hackathon`
--

LOCK TABLES `hackathon` WRITE;
/*!40000 ALTER TABLE `hackathon` DISABLE KEYS */;
/*!40000 ALTER TABLE `hackathon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pow`
--

DROP TABLE IF EXISTS `pow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pow` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `skills` json DEFAULT NULL,
  `link` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `subSkills` json DEFAULT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `like` json DEFAULT NULL,
  `likeCount` int NOT NULL DEFAULT '0',
  `ogImage` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `PoW_userId_idx` (`userId`),
  KEY `PoW_createdAt_idx` (`createdAt`),
  KEY `PoW_likeCount_idx` (`likeCount`),
  KEY `PoW_likeCount_createdAt_idx` (`likeCount` DESC,`createdAt` DESC),
  KEY `PoW_userId_createdAt_idx` (`userId`,`createdAt` DESC),
  KEY `PoW_userId_id_idx` (`userId`,`id`),
  CONSTRAINT `PoW_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pow`
--

LOCK TABLES `pow` WRITE;
/*!40000 ALTER TABLE `pow` DISABLE KEYS */;
/*!40000 ALTER TABLE `pow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resendlogs`
--

DROP TABLE IF EXISTS `resendlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resendlogs` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ResendLogs_email_createdAt_idx` (`email`,`createdAt` DESC),
  KEY `ResendLogs_createdAt_idx` (`createdAt` DESC),
  KEY `ResendLogs_status_idx` (`status`),
  KEY `ResendLogs_email_status_idx` (`email`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resendlogs`
--

LOCK TABLES `resendlogs` WRITE;
/*!40000 ALTER TABLE `resendlogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `resendlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scouts`
--

DROP TABLE IF EXISTS `scouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scouts` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listingId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dollarsEarned` int NOT NULL,
  `score` decimal(9,2) NOT NULL,
  `invited` tinyint(1) NOT NULL,
  `skills` json NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Scouts_userId_listingId_key` (`userId`,`listingId`),
  KEY `Scouts_listingId_idx` (`listingId`),
  KEY `Scouts_listingId_invited_idx` (`listingId`,`invited`),
  KEY `Scouts_listingId_score_idx` (`listingId`,`score` DESC),
  KEY `Scouts_userId_listingId_invited_idx` (`userId`,`listingId`,`invited`),
  KEY `Scouts_score_idx` (`score` DESC),
  CONSTRAINT `Scouts_listingId_fkey` FOREIGN KEY (`listingId`) REFERENCES `bounties` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Scouts_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scouts`
--

LOCK TABLES `scouts` WRITE;
/*!40000 ALTER TABLE `scouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `scouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sessionToken` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Session_sessionToken_key` (`sessionToken`),
  KEY `Session_userId_idx` (`userId`),
  CONSTRAINT `Session_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sponsors`
--

DROP TABLE IF EXISTS `sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sponsors` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `industry` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `twitter` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `entityName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isVerified` tinyint(1) NOT NULL DEFAULT '0',
  `isCaution` tinyint(1) NOT NULL DEFAULT '0',
  `st` tinyint(1) NOT NULL DEFAULT '0',
  `verificationInfo` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Sponsors_name_key` (`name`),
  UNIQUE KEY `Sponsors_slug_key` (`slug`),
  KEY `Sponsors_id_slug_idx` (`id`,`slug`),
  KEY `Sponsors_isVerified_st_idx` (`isVerified`,`st`),
  KEY `Sponsors_isCaution_isVerified_idx` (`isCaution`,`isVerified`),
  KEY `Sponsors_isActive_isArchived_idx` (`isActive`,`isArchived`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sponsors`
--

LOCK TABLES `sponsors` WRITE;
/*!40000 ALTER TABLE `sponsors` DISABLE KEYS */;
/*!40000 ALTER TABLE `sponsors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tweet` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `eligibilityAnswers` json DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listingId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isWinner` tinyint(1) NOT NULL DEFAULT '0',
  `winnerPosition` int DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `like` json DEFAULT NULL,
  `likeCount` int NOT NULL DEFAULT '0',
  `isPaid` tinyint(1) NOT NULL DEFAULT '0',
  `paymentDetails` json DEFAULT NULL,
  `otherInfo` text COLLATE utf8mb4_unicode_ci,
  `ask` int DEFAULT NULL,
  `label` enum('Unreviewed','Reviewed','Shortlisted','Spam','Low_Quality','Mid_Quality','High_Quality','Pending','Inaccessible','Needs_Review') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Unreviewed',
  `rewardInUSD` double NOT NULL DEFAULT '0',
  `ogImage` text COLLATE utf8mb4_unicode_ci,
  `notes` varchar(10000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ai` json DEFAULT NULL,
  `paymentSynced` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `Submission_id_listingId_idx` (`id`,`listingId`),
  KEY `Submission_userId_idx` (`userId`),
  KEY `Submission_listingId_idx` (`listingId`),
  KEY `Submission_isWinner_idx` (`isWinner`),
  KEY `Submission_createdAt_isWinner_idx` (`createdAt`,`isWinner`),
  KEY `Submission_createdAt_listingId_idx` (`createdAt`,`listingId`),
  KEY `Submission_likeCount_idx` (`likeCount`),
  KEY `Submission_listingId_isActive_isArchived_idx` (`listingId`,`isActive`,`isArchived`),
  KEY `Submission_listingId_userId_isActive_isArchived_idx` (`listingId`,`userId`,`isActive`,`isArchived`),
  KEY `Submission_listingId_isWinner_isActive_isArchived_idx` (`listingId`,`isWinner`,`isActive`,`isArchived`),
  KEY `Submission_userId_listingId_createdAt_idx` (`userId`,`listingId`,`createdAt`),
  KEY `Submission_createdAt_idx` (`createdAt` DESC),
  KEY `Submission_likeCount_createdAt_idx` (`likeCount` DESC,`createdAt` DESC),
  CONSTRAINT `Submission_listingId_fkey` FOREIGN KEY (`listingId`) REFERENCES `bounties` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Submission_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission`
--

LOCK TABLES `submission` WRITE;
/*!40000 ALTER TABLE `submission` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribebounty`
--

DROP TABLE IF EXISTS `subscribebounty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscribebounty` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bountyId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `SubscribeBounty_userId_bountyId_key` (`userId`,`bountyId`),
  KEY `SubscribeBounty_bountyId_idx` (`bountyId`),
  KEY `SubscribeBounty_userId_idx` (`userId`),
  KEY `SubscribeBounty_userId_bountyId_idx` (`userId`,`bountyId`),
  KEY `SubscribeBounty_bountyId_isArchived_idx` (`bountyId`,`isArchived`),
  KEY `SubscribeBounty_userId_isArchived_idx` (`userId`,`isArchived`),
  CONSTRAINT `SubscribeBounty_bountyId_fkey` FOREIGN KEY (`bountyId`) REFERENCES `bounties` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `SubscribeBounty_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribebounty`
--

LOCK TABLES `subscribebounty` WRITE;
/*!40000 ALTER TABLE `subscribebounty` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscribebounty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribehackathon`
--

DROP TABLE IF EXISTS `subscribehackathon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscribehackathon` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hackathonId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isArchived` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `SubscribeHackathon_hackathonId_idx` (`hackathonId`),
  KEY `SubscribeHackathon_userId_idx` (`userId`),
  CONSTRAINT `SubscribeHackathon_hackathonId_fkey` FOREIGN KEY (`hackathonId`) REFERENCES `hackathon` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `SubscribeHackathon_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribehackathon`
--

LOCK TABLES `subscribehackathon` WRITE;
/*!40000 ALTER TABLE `subscribehackathon` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscribehackathon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `talentrankings`
--

DROP TABLE IF EXISTS `talentrankings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `talentrankings` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `skill` enum('DEVELOPMENT','DESIGN','CONTENT','OTHER','ALL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL',
  `timeframe` enum('THIS_YEAR','LAST_30_DAYS','LAST_7_DAYS','ALL_TIME') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL_TIME',
  `rank` int NOT NULL,
  `submissions` int NOT NULL DEFAULT '0',
  `winRate` int NOT NULL DEFAULT '0',
  `wins` int NOT NULL DEFAULT '0',
  `totalEarnedInUSD` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TalentRankings_userId_skill_timeframe_key` (`userId`,`skill`,`timeframe`),
  KEY `TalentRankings_skill_timeframe_idx` (`skill`,`timeframe`),
  KEY `TalentRankings_skill_timeframe_rank_idx` (`skill`,`timeframe`,`rank`),
  KEY `TalentRankings_totalEarnedInUSD_idx` (`totalEarnedInUSD` DESC),
  KEY `TalentRankings_rank_idx` (`rank`),
  KEY `TalentRankings_winRate_idx` (`winRate` DESC),
  CONSTRAINT `TalentRankings_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `talentrankings`
--

LOCK TABLES `talentrankings` WRITE;
/*!40000 ALTER TABLE `talentrankings` DISABLE KEYS */;
/*!40000 ALTER TABLE `talentrankings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telegramuser`
--

DROP TABLE IF EXISTS `telegramuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telegramuser` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telegramId` bigint NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chatId` bigint NOT NULL,
  `isSubscribed` tinyint(1) NOT NULL DEFAULT '0',
  `isOnboarded` tinyint(1) NOT NULL DEFAULT '0',
  `preferences` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TelegramUser_telegramId_key` (`telegramId`),
  KEY `TelegramUser_telegramId_idx` (`telegramId`),
  KEY `TelegramUser_userId_idx` (`userId`),
  KEY `TelegramUser_isSubscribed_idx` (`isSubscribed`),
  CONSTRAINT `TelegramUser_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telegramuser`
--

LOCK TABLES `telegramuser` WRITE;
/*!40000 ALTER TABLE `telegramuser` DISABLE KEYS */;
/*!40000 ALTER TABLE `telegramuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unsubscribedemail`
--

DROP TABLE IF EXISTS `unsubscribedemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unsubscribedemail` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UnsubscribedEmail_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unsubscribedemail`
--

LOCK TABLES `unsubscribedemail` WRITE;
/*!40000 ALTER TABLE `unsubscribedemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `unsubscribedemail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `publicKey` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `walletAddress` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` text COLLATE utf8mb4_unicode_ci,
  `firstName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `isVerified` tinyint(1) NOT NULL DEFAULT '0',
  `role` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `isTalentFilled` tinyint(1) NOT NULL DEFAULT '0',
  `interests` text COLLATE utf8mb4_unicode_ci,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `twitter` text COLLATE utf8mb4_unicode_ci,
  `discord` text COLLATE utf8mb4_unicode_ci,
  `github` text COLLATE utf8mb4_unicode_ci,
  `linkedin` text COLLATE utf8mb4_unicode_ci,
  `website` text COLLATE utf8mb4_unicode_ci,
  `telegram` text COLLATE utf8mb4_unicode_ci,
  `community` text COLLATE utf8mb4_unicode_ci,
  `experience` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `superteamLevel` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cryptoExperience` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `workPrefernce` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currentEmployer` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notifications` json DEFAULT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `skills` json DEFAULT NULL,
  `currentSponsorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emailVerified` datetime(3) DEFAULT NULL,
  `hackathonId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `featureModalShown` tinyint(1) NOT NULL DEFAULT '0',
  `surveysShown` json DEFAULT NULL,
  `stRecommended` tinyint(1) NOT NULL DEFAULT '0',
  `acceptedTOS` tinyint(1) NOT NULL DEFAULT '0',
  `stLead` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isBlocked` tinyint(1) NOT NULL DEFAULT '0',
  `privyDid` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isKYCVerified` tinyint(1) NOT NULL DEFAULT '0',
  `kycName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kycCountry` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kycAddress` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kycDOB` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kycIDNumber` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kycIDType` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kycVerifiedAt` datetime(3) DEFAULT NULL,
  `blockRationale` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linkedTwitter` json DEFAULT NULL,
  `referralCode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referredById` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`),
  UNIQUE KEY `User_privyDid_key` (`privyDid`),
  UNIQUE KEY `User_username_key` (`username`),
  UNIQUE KEY `User_referralCode_key` (`referralCode`),
  KEY `User_currentSponsorId_idx` (`currentSponsorId`),
  KEY `User_hackathonId_idx` (`hackathonId`),
  KEY `User_email_idx` (`email`),
  KEY `User_username_idx` (`username`),
  KEY `User_firstName_idx` (`firstName`),
  KEY `User_lastName_idx` (`lastName`),
  KEY `User_location_idx` (`location`),
  KEY `User_referredById_idx` (`referredById`),
  CONSTRAINT `User_currentSponsorId_fkey` FOREIGN KEY (`currentSponsorId`) REFERENCES `sponsors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `User_hackathonId_fkey` FOREIGN KEY (`hackathonId`) REFERENCES `hackathon` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `User_referredById_fkey` FOREIGN KEY (`referredById`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userinvites`
--

DROP TABLE IF EXISTS `userinvites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userinvites` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `senderId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `sponsorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `memberType` enum('ADMIN','MEMBER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEMBER',
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserInvites_token_key` (`token`),
  KEY `UserInvites_senderId_idx` (`senderId`),
  KEY `UserInvites_sponsorId_idx` (`sponsorId`),
  CONSTRAINT `UserInvites_senderId_fkey` FOREIGN KEY (`senderId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `UserInvites_sponsorId_fkey` FOREIGN KEY (`sponsorId`) REFERENCES `sponsors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userinvites`
--

LOCK TABLES `userinvites` WRITE;
/*!40000 ALTER TABLE `userinvites` DISABLE KEYS */;
/*!40000 ALTER TABLE `userinvites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usersponsors`
--

DROP TABLE IF EXISTS `usersponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usersponsors` (
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sponsorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('ADMIN','MEMBER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEMBER',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`userId`,`sponsorId`),
  KEY `UserSponsors_sponsorId_idx` (`sponsorId`),
  CONSTRAINT `UserSponsors_sponsorId_fkey` FOREIGN KEY (`sponsorId`) REFERENCES `sponsors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `UserSponsors_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usersponsors`
--

LOCK TABLES `usersponsors` WRITE;
/*!40000 ALTER TABLE `usersponsors` DISABLE KEYS */;
/*!40000 ALTER TABLE `usersponsors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verificationtoken`
--

DROP TABLE IF EXISTS `verificationtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verificationtoken` (
  `identifier` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires` datetime(3) NOT NULL,
  UNIQUE KEY `VerificationToken_token_key` (`token`),
  UNIQUE KEY `VerificationToken_identifier_token_key` (`identifier`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verificationtoken`
--

LOCK TABLES `verificationtoken` WRITE;
/*!40000 ALTER TABLE `verificationtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `verificationtoken` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-07  0:52:37
