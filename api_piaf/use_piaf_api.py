import requests

def ask_question_to_piaf(question):
    url = "https://piaf.datascience.etalab.studio/models/1/doc-qa"
    data = {"questions": [f"{question}"], "top_k_reader": 3, "top_k_retriever": 5}
    response = requests.post(url, json=data)
    return response.json()['results'][0]['answers'][0]['answer']

if __name__ == '__main__':
    response = ask_question_to_piaf("comment faire une carte d'identité ?")
    print(response)