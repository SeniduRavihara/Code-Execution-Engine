import base64

code = """numbers = [64, 34, 25, 12, 22]
print("Original:", numbers)
for i in range(len(numbers)):
    for j in range(0, len(numbers)-i-1):
        if numbers[j] > numbers[j+1]:
            numbers[j], numbers[j+1] = numbers[j+1], numbers[j]
print("Sorted:", numbers)"""

encoded = base64.b64encode(code.encode()).decode()
print(encoded)
