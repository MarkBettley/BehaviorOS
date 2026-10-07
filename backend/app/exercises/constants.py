"""Static exercise data seeded by Nivel 1.2 migrations.

This module contains only plain Python data so the catalog contract can be
asserted without installing runtime dependencies.
"""

SEEDED_EXERCISES: list[dict] = [
    {
        "id": "EX_1",
        "type": "mindfulness",
        "title": "Guided mindfulness breathing",
        "description": "A guided breathing exercise to reduce anxiety.",
        "instructions": {
            "steps": [
                "Inhale for 4 seconds",
                "Hold for 4 seconds",
                "Exhale for 6 seconds",
            ]
        },
        "duration_seconds": 180,
    }
]
