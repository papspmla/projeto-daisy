# Daisy Clinical Archive
## Cardiac Auscultation Record Structure

Directory:
~/projeto_daisy/data/09_auscultas/

Purpose
------------------------------------------------------------
This directory stores digital cardiac auscultation records
for Daisy.

Each auscultation session may generate:

• audio recordings
• spectrogram images
• contextual metadata

These files represent the primary clinical record and are
kept in the filesystem as the authoritative source.

The database layer of the Daisy system will store only
metadata and file paths.

------------------------------------------------------------
Directory Structure
------------------------------------------------------------

09_auscultas/
    cardiologia/
        audio/
        espectrogramas/
        metadata/

audio/
    Raw audio recordings captured with the digital stethoscope.

spectrogramas/
    Spectrogram images generated from the auscultation audio.

metadata/
    Optional contextual metadata for each auscultation session.

------------------------------------------------------------
File Naming Convention
------------------------------------------------------------

YYYY-MM-DD__HHMM__focus.ext

Where:

focus = mitral | tricuspide

Examples:

2026-03-07__1238__mitral.wav
2026-03-07__1238__mitral.png
2026-03-07__1242__tricuspide.wav
2026-03-07__1242__tricuspide.png

------------------------------------------------------------
Clinical Philosophy
------------------------------------------------------------

The Daisy system preserves the original clinical artifacts
(audio and spectrograms) as immutable historical records.

Database ingestion will occur only at the metadata level,
ensuring that the original clinical evidence remains intact.

------------------------------------------------------------
