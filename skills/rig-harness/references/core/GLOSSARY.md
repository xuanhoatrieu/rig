# Glossary

## Agent
An AI coding collaborator operating inside the repository.

## Harness
The repo-level operating system that tells humans and agents how to turn intent
into safe product changes.

## Invariant Encoding
The pattern and practice of converting an accepted architecture, reliability,
security, or quality rule into repository-native validation with both positive
and negative proof, without creating unapproved policy.

## Work Shapes
The four distinct shapes of repository work: Read-only request, Bounded change,
Durable planned change, and Invariant encoding.

## Evidence Capsule
A machine-authenticated JSON/bundle artifact capturing pinned source revisions,
exact diff hunks, and boundary checks (e.g. during repository onboarding).

## Fresh Rerun
A validation run using a clean, independent agent session under equivalent conditions
to prove that a harness intervention actually resolved the observed friction.

## Product Contract
The current expected behavior of the product. Product docs plus executable tests
become the living contract once implementation exists.

## Plan / Story Packet
A durable work file (`docs/plans/active/<name>.md` or story packet) that describes
the product contract, affected docs, design notes, recovery plan, and validation expectations.

## Feature Intake
The classification step that turns a prompt into tiny, normal, or high-risk
work before implementation begins.

## Durable Layer
The SQLite database (`harness.db`) and CLI (`rig`) that stores operational records
(intakes, stories, decisions, plans, backlog items, traces) as structured, queryable data.

## Trace
A structured record of what an agent did during a task: actions taken, files
read, files changed, decisions made, errors encountered, outcome, score, and any
harness friction discovered.
