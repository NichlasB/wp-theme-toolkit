# Deployment Checklist

Track deployment progress after pre-launch QA passes.

Update the matching row as each deployment phase completes.

## Phase Legend

- P1 - Prepare the local site
- P2 - Set up the GridPane server
- P3 - Install plugins and theme
- P4 - Deploy the child theme via Git
- P5 - Migrate the database and uploads
- P6 - Verify and fix URLs
- P7 - Go live
- P8 - Post-launch workflow confirmed

## Tracking Table

| Project | Theme Root | Deployment Date | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | Notes |
|---------|------------|-----------------|----|----|----|----|----|----|----|----|-------|
| Example Site | /path/to/blocksy-child | YYYY-MM-DD | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | |
| Dr. Morse's TV | C:\Users\Captain\Local Sites\drmorses-tv\app\public\wp-content\themes\blocksy-child | 2026-05-28 | [x] | [x] | [x] | [x] | [x] | [ ] | [ ] | [ ] | Manual LocalWP-to-GridPane DB import, uploads migration, and full local plugin payload sync completed; rollback DB dump saved on GridPane before import. Active plugin count now matches LocalWP at 26. Required pages returned HTTP 200 via GridPane local-resolve checks, but full browser QA for images, forms, and dynamic flows is still pending. |

## Template Row

```text
| [project name] | [child-theme path] | [YYYY-MM-DD] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [notes] |
```

When a deployment is blocked, leave the phase unchecked and note the blocker in the Notes column.