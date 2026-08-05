# Smart Billing Management System — Enterprise Edition

A single-file, browser-based tool that reads Smart billing PDFs, extracts every billing
detail, links each line to a User / Department, and turns it all into dashboards,
reports, analytics and charts. Two roles: an **Administrator** who imports PDFs and
publishes data, and **Department viewers** who sign in to see only their own data.

Runs locally in Chrome/Edge — no server. Sharing is done by publishing **encrypted**
data files to a **private GitHub repo**.

---

## Roles

- **Administrator** — full access: import PDFs, edit, manage users/departments, set
  passwords, and publish encrypted data. Works on the machine that has the PDFs.
- **Department viewer** — signs in with their department + password and sees **only
  their department's** invoices and dashboards. No import, no PDFs, read-only.

On first open, choose **Administrator** and type a new password — that becomes the admin
password (stored only on this machine). Then set each department's password in
**Settings → Access & Passwords**.

---

## Admin: monthly workflow

1. Drop the new month's Smart PDFs into `3. Smart Billing Invoices` (year → month → number).
2. Open the app (double-click `index.html`, or run `START-Smart-Billing.bat`), sign in as Administrator.
3. **Import PDFs → Select Folder.** Import **merges/updates** by phone + billing month, so re-importing never creates duplicates. (If you ever see leftovers from older versions, run **Backup → Rebuild & de-duplicate** once.)
4. Make sure new numbers are linked to a **Department** (Settings → Users) — unassigned lines can only be seen by the admin.
5. Click **Sync** (top bar) — it encrypts every month + manifest and pushes them to the repo in one click. (Or use **Backup → Publish** to download the files and commit them manually.)

That's the "sync." Everyone's dashboard updates on their next sign-in.

### One-click Sync to GitHub (setup once)

1. In GitHub: **Settings → Developer settings → Fine-grained tokens → Generate new token.**
   - **Repository access:** Only select repositories → your billing repo.
   - **Permissions:** Repository permissions → **Contents: Read and write**.
   - Set a short expiry; copy the token.
2. In the app: **Backup, Restore & Publish → One-click Sync**. Fill Owner, Repository,
   Branch (`main`), Data folder (`data`), and paste the token. Click **Save**, then
   **Test connection**.
3. From then on, just click **Sync** after each import. It creates/updates
   `data/index.json` and `data/YYYY-MM.json` automatically.

Notes: the token is stored on the admin machine only (use **Clear token** to remove it).
Run the app via `START-Smart-Billing.bat` (localhost) or a hosted URL so the GitHub API
call is allowed — pushing from a double-clicked `file://` page can be blocked by the browser.

---

## How the encryption works (per-department, envelope)

Each month is split by department. Each department's slice is encrypted with a random
key, and that key is **wrapped** with both the **admin password** and that **department's
password**. Result:

- AR's password decrypts **only** AR. AP's password can't touch AR — there's no AR key
  wrapped for AP.
- The admin password decrypts **everything**.
- Wrong password = rejected by the cipher (not just a UI check).

Passwords live only on the admin's machine (used to encrypt at publish time). The repo
only ever contains ciphertext.

**Security note:** this is real encryption, but once a viewer decrypts, they hold their
own department's data — expected for internal use. Keep the repo **private** and give
repo access only to whoever needs it.

---

## Repo layout (private GitHub repo)

```
index.html
START-Smart-Billing.bat
README.md
.gitignore
data/
  index.json        (manifest: list of months + departments)
  2026-07.json      (that month, encrypted per department)
  2026-08.json
  ...
```

The `.gitignore` already keeps the PDFs out of the repo — you only commit the app +
the encrypted `data/` files. **Do not commit the PDFs.**

---

## Viewers: how they see the dashboard

Host the repo with **GitHub Pages** (or any place that serves the files over `http/https`)
and share the link with the team. A viewer opens it, picks their department, enters the
password you gave them, and sees their dashboards. Viewer mode needs a hosted `http(s)`
address — it can't read the encrypted `data/` files when a page is opened directly from
disk (`file://`). The admin can still work locally from `file://`.

Because the repo is private, only people you grant access to can reach the files, and
the department password gates what each of them can actually read.

---

## Notes

- Handles all Smart layouts, including the new May-2026 unified "BILLING INVOICE" (credits
  like `(1,806.23) CR` read as negatives). A few old scanned/image PDFs have no text layer
  and are skipped (they'd need OCR).
- Data lives in the browser (IndexedDB for the admin; decrypted-in-memory for viewers).
- Backup exports everything (records + user map + departments) as plain JSON for safekeeping —
  keep that file private too.
- Excel export is available in Data Grid and Reports.
