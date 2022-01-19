//
//  InputView.swift
//  TODO
//
//  Created by huluobo on 2022/1/11.
//

import SwiftUI

struct InputView: View {
    
    static var height: CGFloat = 88 + 16
  
    @ObservedObject var vm: InputViewModel
    let onSubmit: ((Todo) -> Void)?
    
    @FocusState var isInputActive: Bool
    
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Do what you want...", text: $vm.text)
                .submitLabel(.done)
                .focused($isInputActive)
                .font(.body.weight(.medium))
                .foregroundColor(Pallet.primary)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .onSubmit {
                    vm.submit()
                    onSubmit?(vm.todo!)
                    vm.reset()
                    isInputActive = false
                }
        
            InputToolBar(vm: vm)
                 .opacity(alpha)
                 .animation(.linear(duration: 0.2), value: alpha)
            
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Pallet.systemBackground)
        .sheet(isPresented: $vm.showsDatePicker) {
            
        } content: {
            DatePickView(date: $vm.dateForDatePicker) { date in
                vm.pickDate(date)
            }
        }
    }
    
    var alpha: Double {
        isInputActive ? 1 : 0
    }
}
//
//struct NewItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputView(text: Binding.constant("123")) { _ in
//
//        }
//    }
//}
