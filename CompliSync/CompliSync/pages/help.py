import flet as ft
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase
cred = credentials.Certificate(
    "automatedcompliancetool-firebase-adminsdk-fbsvc-d4b06a8810.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


def submit_form(e, name_field, email_field, message_field, status_text):
    """Handles form submission and sends data to Firebase."""
    name = name_field.value.strip()
    email = email_field.value.strip()
    message = message_field.value.strip()

    if not name or not email or not message:
        status_text.value = "⚠️ Please fill in all fields!"
        status_text.color = "red"
        e.page.update()
        return

    # Add data to Firestore
    db.collection("contact_messages").add({
        "name": name,
        "email": email,
        "message": message,
    })

    # Success message
    status_text.value = "✅ Message sent successfully!"
    status_text.color = "green"
    name_field.value = ""
    email_field.value = ""
    message_field.value = ""

    e.page.update()


def submit_faq(e, question_field):
    """Handles FAQ submission."""
    question = question_field.value.strip()

    if not question:
        return

    # Add question to Firestore with a placeholder answer
    db.collection("faqs").add(
        {"question": question, "answer": "Pending response from admin..."}
    )

    # Clear input field
    question_field.value = ""
    e.page.update()


def load_faqs(faq_list):
    """Real-time listener for FAQs."""
    def on_snapshot(snapshot, changes, read_time):
        faq_list.controls.clear()

        for faq in snapshot:
            data = faq.to_dict()
            if 'question' in data and 'answer' in data:
                faq_list.controls.append(
                    ft.Text(f"❓ {data['question']}", size=18, weight=ft.FontWeight.BOLD))
                faq_list.controls.append(ft.Text(f"💬 {data['answer']}", size=16))

        faq_list.update()

    # Listen to Firestore updates
    db.collection("faqs").on_snapshot(on_snapshot)


def submit_feedback(e, feedback_field, rating_field):
    """Handles feedback submission."""
    feedback = feedback_field.value.strip()
    rating = rating_field.value.strip()

    if not feedback or not rating:
        return

    # Add feedback to Firestore
    db.collection("feedback").add({"feedback": feedback, "rating": rating})

    # Clear input fields
    feedback_field.value = ""
    rating_field.value = ""
    e.page.update()


def load_feedback(feedback_list):
    """Real-time listener for feedback."""
    def on_snapshot(snapshot, changes, read_time):
        feedback_list.controls.clear()

        for fb in snapshot:
            data = fb.to_dict()
            if 'rating' in data and 'feedback' in data:
                feedback_list.controls.append(
                    ft.Text(f"⭐ {data['rating']} - {data['feedback']}", size=16))

        feedback_list.update()

    # Listen to Firestore updates
    db.collection("feedback").on_snapshot(on_snapshot)


def help():
    name_field = ft.TextField(label="Your Name", width=300)
    email_field = ft.TextField(label="Your Email", width=300)
    message_field = ft.TextField(
        label="Your Message", width=300, multiline=True, max_lines=5)
    status_text = ft.Text("", size=16)

    submit_button = ft.ElevatedButton(
        "Send Message",
        on_click=lambda e: submit_form(
            e, name_field, email_field, message_field, status_text),
    )

    # Real-time FAQ section
    question_field = ft.TextField(label="Ask a question...", width=400)
    faq_list = ft.Column([])
    faq_submit_button = ft.ElevatedButton(
        "Submit Question", on_click=lambda e: submit_faq(e, question_field))

    # Feedback Section
    feedback_field = ft.TextField(
        label="Your Feedback", width=400, multiline=True, max_lines=3)
    rating_field = ft.TextField(label="Rating (1-5)", width=100)
    feedback_list = ft.Column([])
    feedback_submit_button = ft.ElevatedButton(
        "Submit Feedback", on_click=lambda e: submit_feedback(e, feedback_field, rating_field))

    # Load FAQs and Feedback in real-time
    load_faqs(faq_list)
    load_feedback(feedback_list)

    url = "https://learn.cisecurity.org/benchmarks"

    def copy_to_clipboard(e):
        e.page.set_clipboard(url)
        e.page.snack_bar = ft.SnackBar(ft.Text("System info copied to clipboard!"), open=True)
        e.page.update()

    return ft.Container(
        content=ft.Column(
            [
                ft.Text("Help & Support", size=32, weight=ft.FontWeight.BOLD),
                ft.Divider(),
                ft.Text("PDF Download Steps:", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "1. Open the link below in any web browser.\n"
                    "2. Register by providing your details.\n"
                    "3. Check your email inbox for the access link and click on it.\n"
                    "4. Scroll down to the \"Operating Systems\" section and expand the dropdown for \"Microsoft Windows Desktop\".\n"
                    "5. Click on the 'Download PDF' button next to the entry like \"CIS Microsoft Windows 11 Enterprise Benchmark v4.0.0\".\n"
                    "6. Use the downloaded PDF in the Compliance & Audit page.\n\n"
                    "Note: The benchmark version may vary. Always download the latest version of the PDF for "
                    "\"CIS Microsoft Windows 11 Enterprise Benchmark\".",
                    size=16
                ),
                ft.Text("PDF Download Link:", size=18, weight=ft.FontWeight.BOLD),
                ft.Row(
                    [
                        ft.Text("https://learn.cisecurity.org/benchmarks", size=16,),
                        ft.IconButton(
                            icon=ft.icons.CONTENT_COPY,
                            tooltip="Copy Info",
                            on_click=copy_to_clipboard,
                            icon_size=16,
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.START,
                ),
                ft.Divider(),
                ft.Text(
                    "Welcome to the Help & Support Page.", size=18),
                ft.Text("Frequently Asked Questions (FAQs):",
                        size=20, weight=ft.FontWeight.BOLD),
                ft.Text("1. What is the CIS Benchmark?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "CIS Benchmarks are secure configuration guidelines developed by the Center for Internet Security (CIS) to help organizations improve their cybersecurity posture.", size=16),

                ft.Text("2. How does this compliance tool work?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "The tool scans your system configurations and compares them against the recommended settings defined in the CIS Benchmarks.", size=16),

                ft.Text("3. Why is CIS Benchmark compliance important?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "Compliance ensures systems follow industry-recognized best practices, reducing vulnerabilities and improving overall security.", size=16),

                ft.Text("4. Does this tool support multiple operating systems?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "No, the tool currently supports only Microsoft Windows 11 Enterprise Edition.", size=16),

                ft.Text("5. How often should I run the compliance check?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "You should run compliance checks regularly—preferably weekly or after major system changes—to maintain security alignment.", size=16),

                ft.Text("6. Can I customize the compliance rules?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "Yes, you can tailor compliance rules based on your organization's risk profile and internal security policies.", size=16),

                ft.Text("7. What happens if my system fails a compliance check?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "The tool will highlight non-compliant settings and provide detailed guidance on how to remediate each issue through the Information Page.", size=16),

                ft.Text("8. Does this tool provide automated remediation?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "Yes, the tool supports automated remediation with option to batch audit or single audit.", size=16),

                ft.Text("9. How do I get updates for new CIS Benchmarks?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "You can download the latest CIS Benchmarks from the steps provided above and use the latest Benchmarks in Compliance & Audit Page.", size=16),

                ft.Text("10. Can I export compliance reports?", size=18, weight=ft.FontWeight.BOLD),
                ft.Text(
                    "Yes, you can export compliance reports in both JSON and CSV formats for auditing, reporting, or sharing purposes.", size=16),

                ft.Divider(),

                # Real-Time FAQ Submission
                ft.Text("🔍 Ask a Question", size=20,
                        weight=ft.FontWeight.BOLD),
                question_field,
                faq_submit_button,
                faq_list,

                ft.Divider(),
                ft.Text("📨 Contact Administrator", size=20,
                        weight=ft.FontWeight.BOLD),
                name_field,
                email_field,
                message_field,
                submit_button,
                status_text,

                ft.Divider(),
                ft.Text("📝 Submit Feedback", size=20,
                        weight=ft.FontWeight.BOLD),
                feedback_field,
                rating_field,
                feedback_submit_button,
                feedback_list,
            ],
            spacing=10,
            scroll="auto",
        ),
        padding=20,
        expand=True,
    )
