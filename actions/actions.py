# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/core/actions/#custom-actions/


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List, Union

from rasa_sdk.events import AllSlotsReset

from rasa_sdk.forms import FormAction
from rasa_sdk import Tracker
from rasa_sdk.executor import CollectingDispatcher
from .api_piaf.use_piaf_api import ask_question_to_piaf


class QuestionForm(FormAction):
    """Collects sales information and adds it to the spreadsheet"""

    def name(self):
        return "form_poser_question"

    @staticmethod
    def required_slots(tracker):
        return [
            "question",
        ]

    def slot_mappings(self) -> Dict[Text, Union[Dict, List[Dict]]]:
        """A dictionary to map required slots to
            - an extracted entity
            - intent: value pairs
            - a whole message
            or a list of them, where a first match will be picked"""

        return {
            "question": self.from_text(intent=None),
        }

    def submit(
            self,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any],
    ) -> List[Dict]:
        question = tracker.get_slot('question')
        response = ask_question_to_piaf(question)
        if response['probability'] > 0.80:
            dispatcher.utter_message(f"J'ai trouvé la réponse suivante: \n {response['answer']}")
            dispatcher.utter_message(f"Dans le corps de texte suivant: {response['context']}")
            dispatcher.utter_message(template='utter_are_you_satisfied')
        else:
            dispatcher.utter_message(f"C'est embarrassant ... je n'arrive pas à trouver la réponse à la question: '{question}'")
            dispatcher.utter_message(template='utter_bad_answer')
        return [AllSlotsReset()]

