# EcoHabit — User Personas

**Document Reference**: PRD v1.0, Section 4
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

EcoHabit serves four distinct user groups. Each persona represents a primary user type with specific goals, pain points, and feature usage patterns.

| Persona | Role | Primary Goal |
|---|---|---|
| Aisha | Student Seller | Sell used items sustainably |
| Rahul | Student Buyer | Find affordable used items |
| Priya | NGO Coordinator | Organize donation drives |
| Dr. Sharma | Campus Administrator | Track sustainability metrics |

---

## Persona 1: Aisha — The Sustainable Seller

### Demographics
- **Age**: 21
- **Occupation**: Engineering student
- **Living Situation**: College hostel
- **Technical Proficiency**: High
- **Device**: Android smartphone
- **Connectivity**: Wi-Fi (hostel), 4G (mobile)

### Goals
- Sell used textbooks and electronics before graduation
- Earn recognition for sustainable behavior
- Reduce personal waste footprint
- Learn basic entrepreneurship

### Pain Points
- No efficient way to sell items to juniors
- Existing platforms (OLX, Facebook Marketplace) aren't student-focused
- Doesn't know how to recycle electronics properly
- Wants to track environmental impact

### EcoHabit Features Used
- Marketplace Listings (create, manage)
- AI Scanner (waste classification)
- Eco Rewards (points, badges)
- Community Feed (sharing projects)

### Key Journeys
- Sell Marketplace Listing (primary)
- AI Scan (secondary)
- Community Post (tertiary)

### Success Looks Like
- Sells 5+ items before graduation
- Earns "First Sale" badge within first week
- Reduces personal waste by tracking impact
- Becomes a top seller on campus leaderboard

### Quote
> "I have so many things I don't need anymore. I wish there was an easy way to sell them to juniors and feel good about it."

---

## Persona 2: Rahul — The Budget Buyer

### Demographics
- **Age**: 19
- **Occupation**: First-year student
- **Living Situation**: College hostel
- **Technical Proficiency**: Medium
- **Device**: Android smartphone
- **Connectivity**: Wi-Fi (campus), Limited 4G

### Goals
- Find affordable textbooks and supplies
- Buy quality used items at discount
- Learn about sustainability
- Discover DIY projects

### Pain Points
- New textbooks are expensive
- Doesn't know where to find used items on campus
- Wants to make sustainable choices but needs guidance
- Limited budget for supplies

### EcoHabit Features Used
- Marketplace (browse, search, buy)
- DIY Studio (browse projects)
- Community Feed (sustainability tips)
- AI Scanner (learn about waste)

### Key Journeys
- Buy Marketplace Listing (primary)
- Browse DIY Projects (secondary)
- Community Post (tertiary)

### Success Looks Like
- Finds affordable textbooks within first week
- Saves 30%+ on supplies through used items
- Completes first DIY project
- Shares a sustainability tip with community

### Quote
> "I need textbooks but can't afford new ones. It would be great to find used books from seniors."

---

## Persona 3: Priya — The NGO Coordinator

### Demographics
- **Age**: 25
- **Occupation**: Works with campus environmental NGO
- **Living Situation**: Off-campus
- **Technical Proficiency**: Medium-High
- **Device**: Android/iOS smartphone, Laptop
- **Connectivity**: Reliable 4G, Home Wi-Fi

### Goals
- Organize donation drives efficiently
- Connect with student volunteers
- Track environmental impact metrics
- Raise awareness about sustainability

### Pain Points
- Difficulty reaching students for donations
- Manual tracking of donations and volunteers
- No centralized platform for campus sustainability initiatives
- Hard to measure impact of campaigns

### EcoHabit Features Used
- Community Feed (organize drives)
- Donation Listings (V2)
- Impact Dashboard (V2)
- Reports (flag inappropriate content)

### Key Journeys
- Community Post (primary)
- Report Content (secondary)
- AI Scan (tertiary)

### Success Looks Like
- Organizes 2+ donation drives per semester
- Reaches 100+ students per campaign
- Tracks volunteer participation digitally
- Reports measurable environmental impact

### Quote
> "We organize donation drives every semester, but it's hard to reach students and track who contributed what."

---

## Persona 4: Dr. Sharma — The Campus Administrator

### Demographics
- **Age**: 45
- **Occupation**: Dean of Student Affairs
- **Living Situation**: Off-campus
- **Technical Proficiency**: Low-Medium
- **Device**: Laptop, Basic smartphone
- **Connectivity**: Office Wi-Fi, Limited mobile data

### Goals
- Track campus sustainability metrics
- Support student environmental initiatives
- Reduce campus waste management costs
- Report to university administration

### Pain Points
- No visibility into campus sustainability efforts
- Difficulty measuring impact of green initiatives
- Limited tools for student engagement
- Need data for reports

### EcoHabit Features Used
- Organization Dashboard (V2)
- Analytics and Reports (V2)
- User Management (Admin)

### Key Journeys
- View Analytics (primary)
- Manage Users (secondary)
- Review Reports (tertiary)

### Success Looks Like
- Accesses real-time sustainability dashboard
- Generates monthly impact reports
- Supports 5+ student initiatives per year
- Reduces campus waste costs by 10%

### Quote
> "I need concrete data on our campus sustainability efforts to justify budget allocation for green initiatives."

---

## Persona Comparison Matrix

| Dimension | Aisha | Rahul | Priya | Dr. Sharma |
|---|---|---|---|---|
| **Role** | Student Seller | Student Buyer | NGO Coordinator | Administrator |
| **Age Range** | 20-22 | 18-20 | 24-26 | 40-50 |
| **Primary Goal** | Sell items | Buy items | Organize drives | Track metrics |
| **Technical Proficiency** | High | Medium | Medium-High | Low-Medium |
| **Usage Frequency** | Daily | Weekly | Weekly | Monthly |
| **Key Features** | Marketplace, Scanner | Marketplace, DIY | Community, Reports | Dashboard, Analytics |
| **Value to Platform** | Listings supply | Demand + engagement | Content + events | Institutional support |
| **Monetary Motivation** | High | High | Low | None |
| **Sustainability Motivation** | Medium | Low-Medium | High | Medium |
| **Key Journeys** | Sell, Scan, Post | Buy, Browse DIY, Post | Post, Report, Scan | Analytics, Manage, Review |
| **Success Metric** | Items sold, badges | Money saved, projects | Drives organized, reach | Reports generated, impact |

---

## Persona-to-Feature Mapping

| Feature | Aisha | Rahul | Priya | Dr. Sharma |
|---|---|---|---|---|
| Authentication | ✅ | ✅ | ✅ | ✅ |
| Home Dashboard | ✅ | ✅ | ✅ | ✅ |
| Marketplace Browse | ⬜ | ✅ | ⬜ | ⬜ |
| Create Marketplace Listing | ✅ | ⬜ | ⬜ | ⬜ |
| AI Scanner | ✅ | ✅ | ✅ | ⬜ |
| DIY Studio | ⬜ | ✅ | ⬜ | ⬜ |
| Community Feed | ✅ | ✅ | ✅ | ⬜ |
| Eco Rewards | ✅ | ✅ | ✅ | ⬜ |
| Profile | ✅ | ✅ | ✅ | ✅ |
| Admin Dashboard | ⬜ | ⬜ | ⬜ | ✅ |
| Reports | ⬜ | ⬜ | ✅ | ✅ |

**Legend**: ✅ = Primary user, ⬜ = Rarely/never uses

---

## User Distribution Estimate (MVP)

| Persona | % of Users | Estimated Count (500 users) |
|---|---|---|
| Student Seller | 40% | 200 |
| Student Buyer | 45% | 225 |
| NGO Coordinator | 10% | 50 |
| Campus Administrator | 5% | 25 |

---

## Document Reference

This document references:
- PRD v1.0, Section 4 (Target Users & Personas)
- PRD v1.0, Section 6 (MVP Feature Specification)
- PRD v1.0, Section 11 (User Journeys)

This document is referenced by:
- 04_User_Journeys.md
